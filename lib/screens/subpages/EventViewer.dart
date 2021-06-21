import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/EventImage.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'PhotoViewer.dart';

class EventViewer extends StatefulWidget {
  final PeopleEvent event;
  final AccountData user;
  final EventImage eventImage;

  EventViewer({this.event, this.user, this.eventImage});

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
          }) :
          IconButton(icon: Icon(Icons.bookmark_border_rounded), onPressed: () {
            _database.markEvent(widget.event.eventId);
            setState(() {});
          })
        ] : null,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 200, child: widget.eventImage.banner),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.event.eventName, style: theme.textTheme.headline4),
                  Text(widget.event.hostName, style: theme.textTheme.subtitle1),
                  Text(widget.event.address, style: theme.textTheme.subtitle2),
                  Divider(),
                  Text(widget.event.description, style: theme.textTheme.bodyText2),
                  Divider(),
                  SizedBox(height: 50),
                  Text('Showcases', style: theme.textTheme.headline6),
                  carousel(widget.eventImage.showcases, 'Showcase'),
                  Text('Permits', style: theme.textTheme.headline6),
                  carousel(widget.eventImage.permits, 'Permit'),
                ],
              ),
            )
          ],
        ),
      ),
    ) : Loading();
  }
}

