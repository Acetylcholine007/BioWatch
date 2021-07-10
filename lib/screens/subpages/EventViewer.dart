import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Enum.dart';
import 'package:bio_watch/models/EventImage.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/screens/subpages/PhotoViewer.dart';
import 'package:bio_watch/screens/subpages/UserViewer.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewer extends StatefulWidget {
  final PeopleEvent event;
  final AccountData user;
  final EventImage eventImage;
  final Future<String> interestedCount;

  EventViewer({this.event, this.user, this.eventImage, this.interestedCount});

  @override
  _EventViewerState createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {
  final StorageService _storage = StorageService();

  CarouselSlider carousel(List<Image> images, String title) {
    return CarouselSlider(
      options: CarouselOptions(height: 250.0),
      items: images.map((image) {
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoViewer(title: title, image: image))),
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: image
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnded = DateTime.now().compareTo(widget.event.datetime) == 1 ? true : false;
    final DatabaseService _database = DatabaseService(uid: widget.user.uid);
    final eventIds = Provider.of<List<String>>(context);
    final theme = Theme.of(context);
    final Widget loadingWidget = Center(child: CircularProgressIndicator());

    return eventIds != null ? Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: widget.user.accountType == 'USER' ? [
          eventIds.indexOf(widget.event.eventId) != -1 ?
          IconButton(icon: Icon(Icons.bookmark_rounded), onPressed: () {
            if(isEnded) {
              _database.removeToMyEvents(widget.event.eventId);
            } else {
              _database.unmarkEvent(widget.event.eventId, Activity(
                heading: 'Event Unmarked',
                datetime: DateTime.now().toString(),
                body: 'You\'ve unmarked ${widget.event.eventName}',
                type: ActivityType.unmarkEvent
              ));
              setState(() {});
              final snackBar = SnackBar(
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                content: Text('Removed from interests'),
                action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }) :
          IconButton(icon: Icon(Icons.bookmark_border_rounded), onPressed: () {
            if(isEnded) {
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Mark Event'),
                  content: Text('Can no longer mark an event that ended'),
                  actions: [
                    TextButton(onPressed: () async {
                      Navigator.of(context).pop();
                    }, child: Text('OK'))
                  ],
                );
              });
            } else {
              showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Mark Event'),
                  content: Text('Marking this event will make your credentials visible to the host of the event. Make sure you trust the event before marking it.'),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                      _database.markEvent(widget.event.eventId, Activity(
                        heading: 'Event Marked',
                        datetime: DateTime.now().toString(),
                        body: 'You\'ve marked ${widget.event.eventName}',
                        type: ActivityType.markEvent
                      ));
                      setState(() {});
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        content: Text('Added to interests'),
                        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }, child: Text('PROCEED')),
                    TextButton(onPressed: () async {
                      Navigator.of(context).pop();
                    }, child: Text('CANCEL'))
                  ],
                );
              });
            }
          })
        ] : null,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 180, child: OverflowBox(
              child: FutureBuilder<Widget>(
                initialData: loadingWidget,
                future: _storage.getBannerImage(widget.event.eventId, widget.event.bannerUri),
                builder: (context, snapshot) {
                  return snapshot.data;
                },
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.event.eventName, style: theme.textTheme.headline4),
                            SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: RichText(text: TextSpan(children: [
                                WidgetSpan(child: Icon(Icons.event_rounded, color: theme.accentColor, size: 16)),
                                TextSpan(
                                  text: isEnded ? ' EVENT ENDED' : ' ' + dateTimeFormatter.format(widget.event.datetime),
                                  style: theme.textTheme.subtitle2
                                ),
                              ])),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: RichText(text: TextSpan(children: [
                                WidgetSpan(child: Icon(Icons.location_on_rounded, color: theme.accentColor, size: 16)),
                                TextSpan(text: ' ' + widget.event.address, style: theme.textTheme.subtitle2),
                              ])),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FutureBuilder(
                                future: _database.getAccount(widget.event.hostId),
                                builder: (context, snapshot) {
                                  if(snapshot.connectionState == ConnectionState.done) {
                                    return UserViewer(accountData: snapshot.data);
                                  } else {
                                    return Loading('Loading User Data');
                                  }
                                },
                              ))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: RichText(text: TextSpan(children: [
                                  WidgetSpan(child: Icon(Icons.badge, color: theme.accentColor, size: 16)),
                                  TextSpan(text: ' Hosted by: ' + widget.event.hostName + ' ', style: theme.textTheme.subtitle2.copyWith(color: theme.primaryColor)),
                                  WidgetSpan(child: Icon(Icons.launch_rounded, color: theme.primaryColor, size: 16)),
                                ])),
                              ),
                              //child: Text('Hosted by: ' + widget.event.hostName, style: theme.textTheme.subtitle2.copyWith(color: theme.accentColor)),
                            ),
                          ],
                        )
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: FutureBuilder(
                            initialData: '',
                            future: widget.interestedCount,
                            builder: (context, snapshot) {
                              return RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${snapshot.data}\n',
                                      style: theme.textTheme.headline6
                                    ),
                                    WidgetSpan(
                                      child: Icon(Icons.bookmark_rounded, color: theme.accentColor, size: 40),
                                    ),
                                  ],
                                ),
                              );
                            }
                          ),
                        )
                      ),
                    ],
                  ),
                  Divider(height: 20),
                  Text(widget.event.description, style: theme.textTheme.bodyText2),
                  Divider(height: 20),
                  Text('Showcases', style: theme.textTheme.headline5),
                  FutureBuilder<List<Image>>(
                    initialData: [Image.asset('assets/placeholder.jpg', fit: BoxFit.cover)],
                    future: _storage.getShowcaseImages(widget.event.eventId, widget.event.showcaseUris),
                    builder: (context, snapshot) {
                      return carousel(snapshot.data, 'Showcases');
                    }
                  ),
                  Text('Permits', style: theme.textTheme.headline5),
                  FutureBuilder<List<Image>>(
                    initialData: [Image.asset('assets/placeholder.jpg', fit: BoxFit.cover)],
                    future: _storage.getPermitImages(widget.event.eventId, widget.event.permitUris),
                    builder: (context, snapshot) {
                      return carousel(snapshot.data, 'Permits');
                    }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ) : Loading('Loading Event Data');
  }
}

