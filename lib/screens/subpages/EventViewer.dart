import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/models/Person.dart';
import 'package:bio_watch/shared/DataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventViewer extends StatefulWidget {
  final PeopleEvent event;
  final Person user;

  EventViewer({this.event, this.user});

  @override
  _EventViewerState createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<String> eventIds = widget.user.myEvents;
    Function addInterested = Provider.of<DataProvider>(context, listen: true).addInterested;
    Function removeInterested = Provider.of<DataProvider>(context, listen: true).removeInterested;

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: widget.user.accountType == 'HOST' ? null : [
          eventIds.indexOf(widget.event.id) != -1 ?
          IconButton(icon: Icon(Icons.bookmark_rounded), onPressed: () => removeInterested(widget.event.id, widget.user.id)) :
          IconButton(icon: Icon(Icons.bookmark_border_rounded), onPressed: () => addInterested(widget.event.id, widget.user.id))
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

