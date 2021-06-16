import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/components/QRDisplay.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/EventImage.dart';
import 'package:bio_watch/models/Interested.dart';
import 'package:bio_watch/models/Participant.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/screens/subpages/EventEditor.dart';
import 'package:bio_watch/screens/subpages/UserList.dart';
import 'package:bio_watch/screens/subpages/Statistics.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDashboard extends StatefulWidget {
  final PeopleEvent event;

  EventDashboard({this.event});

  @override
  _EventDashboardState createState() => _EventDashboardState();
}

class _EventDashboardState extends State<EventDashboard> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Account>(context);
    final interested = Provider.of<List<Interested>>(context);
    final participants = Provider.of<List<Participant>>(context);
    final DatabaseService _database = DatabaseService(uid: user.uid);

    return interested != null && participants != null ? DefaultTabController(
      length: 3,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Event Dashboard'),
            actions: [
              IconButton(icon: Icon(Icons.edit_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FutureBuilder(
                //TODO: Implement file fetching
                  future: null,
                builder: (context, snapshot) {
                  if(/*snapshot.connectionState == ConnectionState.done*/ true) {
                    return EventEditor(event: widget.event, isNew: false, eventImage: EventImage());
                  } else {
                    return Loading();
                  }
                }
              )))),
              IconButton(icon: Icon(Icons.import_export_rounded), onPressed: () {}),
              IconButton(icon: Icon(Icons.qr_code_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QRDisplay(eventId: widget.event.eventId)))),
              IconButton(icon: Icon(Icons.cancel_outlined), onPressed: () {
                _database.cancelEvent(widget.event.eventId, Activity(
                  heading: 'Event Cancelled',
                  time: TimeOfDay.now().format(context).split(' ')[0],
                  date: DateTime.now().toString(),
                  body: 'You\'ve cancelled ${widget.event.eventName}'
                ));
                Navigator.of(context).pop();
              })
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
              UserList(userIds: interested.map((interested) => interested.uid).toList()),
              UserList(userIds: participants.map((participant) => participant.uid).toList())
            ],
          )
        ),
      ),
    ) : Loading();
  }
}
