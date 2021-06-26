import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/EventImage.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/screens/subpages/PhotoViewer.dart';
import 'package:bio_watch/screens/subpages/UserViewer.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EventViewer extends StatefulWidget {
  final PeopleEvent event;
  final AccountData user;
  final EventImage eventImage;
  final String interestedCount;

  EventViewer({this.event, this.user, this.eventImage, this.interestedCount});

  @override
  _EventViewerState createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {

  CarouselSlider carousel(List<Image> images, String title) {
    return CarouselSlider(
      options: CarouselOptions(height: 250.0),
      items: images.map((image) {
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoViewer(title: title, image: image))),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: image),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService _database = DatabaseService(uid: widget.user.uid);
    final eventIds = Provider.of<List<String>>(context);
    final theme = Theme.of(context);

    return eventIds != null ? Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: widget.user.accountType == 'USER' ? [
          eventIds.indexOf(widget.event.eventId) != -1 ?
          IconButton(icon: Icon(Icons.bookmark_rounded), onPressed: () {
            _database.unmarkEvent(widget.event.eventId);
            setState(() {});
            final snackBar = SnackBar(
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              content: Text('Removed from interests'),
              action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }) :
          IconButton(icon: Icon(Icons.bookmark_border_rounded), onPressed: () {
            _database.markEvent(widget.event.eventId);
            setState(() {});
            final snackBar = SnackBar(
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              content: Text('Added to interests'),
              action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          })
        ] : null,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 180, child: OverflowBox(
              maxHeight: 180,
              child: widget.eventImage != null ? widget.eventImage.banner : Image(
                image: AssetImage('assets/placeholder.jpg'),
                fit: BoxFit.cover
              )
            )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.event.eventName, style: theme.textTheme.headline4),
                  Text(widget.event.date + ' ' + widget.event.time, style: theme.textTheme.subtitle2),
                  Text(widget.event.address, style: theme.textTheme.subtitle2),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FutureBuilder(
                      future: _database.getAccount(widget.event.hostId),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.done) {
                          return UserViewer(user: snapshot.data);
                        } else {
                          return Loading();
                        }
                      },
                    ))),
                    child: Text('Hosted by: ' + widget.event.hostName),
                  ),
                  Text('Interested: ${widget.interestedCount}', style: theme.textTheme.subtitle2),
                  Divider(),
                  Text(widget.event.description, style: theme.textTheme.bodyText2),
                  Divider(),
                  SizedBox(height: 20),
                  Text('Showcases', style: theme.textTheme.headline6),
                  carousel(widget.eventImage != null ? widget.eventImage.showcases : [Image(image: AssetImage('assets/placeholder.jpg'))], 'Showcase'),
                  Text('Permits', style: theme.textTheme.headline6),
                  carousel(widget.eventImage != null ? widget.eventImage.permits : [Image(image: AssetImage('assets/placeholder.jpg'))], 'Permit'),
                ],
              ),
            )
          ],
        ),
      ),
    ) : Loading();
  }
}

