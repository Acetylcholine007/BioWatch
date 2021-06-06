import 'package:bio_watch/components/QRDisplay.dart';
import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/screens/subpages/EventEditor.dart';
import 'package:bio_watch/screens/subpages/UserList.dart';
import 'package:bio_watch/screens/subpages/Statistics.dart';
import 'package:flutter/material.dart';

class EventDashboard extends StatefulWidget {
  final PeopleEvent event;

  EventDashboard({this.event});

  @override
  _EventDashboardState createState() => _EventDashboardState();
}

class _EventDashboardState extends State<EventDashboard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Event Dashboard'),
            actions: [
              IconButton(icon: Icon(Icons.edit_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventEditor(event: widget.event, isNew: false)))),
              IconButton(icon: Icon(Icons.import_export_rounded), onPressed: () {}),
              IconButton(icon: Icon(Icons.qr_code_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QRDisplay(eventId: widget.event.id)))),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'STATISTICS'),
                Tab(text: 'INTERESTED'),
                Tab(text: 'PARTICIPANTS')
              ]
            ),
          ),
          body: TabBarView(
            children: [
              Statistics(),
              UserList(userIds: widget.event.interested),
              UserList(userIds: widget.event.participants)
            ],
          )
        ),
      ),
    );
  }
}
