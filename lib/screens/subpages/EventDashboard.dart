import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/components/QRDisplay.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/EventAsset.dart';
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
  final Function refresh;
  final EventAsset eventAsset;

  EventDashboard({this.event, this.refresh, this.eventAsset});

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
              IconButton(icon: Icon(Icons.qr_code_rounded), onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => QRDisplay(data: widget.event.eventId + '<=>' + widget.event.eventName)))
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert_rounded),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                          EventEditor(
                            event: widget.event,
                            isNew: false,
                            eventAsset: widget.eventAsset,
                            refresh: widget.refresh
                          )
                      ));
                    },
                    child: Text('Edit Event')
                  )),
                  PopupMenuItem(child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _database.cancelEvent(widget.event.eventId, Activity(
                        heading: 'Event Cancelled',
                        time: TimeOfDay.now().format(context).split(' ')[0],
                        date: DateTime.now().toString(),
                        body: 'You\'ve cancelled ${widget.event.eventName}'
                      ));
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        content: Text('Event Cancelled'),
                        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel Event')
                  )),
                  PopupMenuItem(child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        content: Text('Data Exported'),
                        action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Text('Export Data')
                  )),
                ],
              ),
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
              //TODO: Move User extraction future here
              FutureBuilder(
                future: _database.interestedUsers(interested.map((interested) => interested.uid).toList()),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    return UserList(users: snapshot.data, type: 'INTERESTED');
                  } else {
                    return Loading();
                  }
                }
              ),
              FutureBuilder(
                future: _database.participantUsers(participants.map((participant) => participant.uid).toList()),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done) {
                    return UserList(users: snapshot.data, type: 'PARTICIPANT');
                  } else {
                    return Loading();
                  }
                }
              )
            ],
          )
        ),
      ),
    ) : Loading();
  }
}
