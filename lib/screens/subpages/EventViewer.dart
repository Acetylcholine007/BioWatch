import 'package:bio_watch/models/Event.dart';
import 'package:flutter/material.dart';

class EventViewer extends StatefulWidget {
  final PeopleEvent event;
  final Function callback;

  EventViewer({this.event, this.callback});

  @override
  _EventViewerState createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: [
          IconButton(icon: Icon(Icons.bookmark_border_rounded), onPressed: widget.callback)
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Image(image: AssetImage(widget.event.bannerUri), fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.event.eventName, style: theme.textTheme.headline6),
                  Text(widget.event.hostName, style: theme.textTheme.subtitle1),
                  Text(widget.event.address, style: theme.textTheme.subtitle2),
                  Divider(),
                  Text(widget.event.description, style: theme.textTheme.bodyText2)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

