import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/components/QRDisplay.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Enum.dart';
import 'package:bio_watch/shared/DataManager.dart';
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
    final isEnded = DateTime.now().compareTo(widget.event.datetime) == 1;

    if(interested != null && participants != null) {
      return DefaultTabController(
        length: 3,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset : false,
            appBar: AppBar(
              title: Text(widget.event.eventName),
              actions: [
                IconButton(icon: Icon(Icons.qr_code_rounded), onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QRDisplay(title: widget.event.eventName, data: widget.event.eventId + '<=Biowatch=>' + widget.event.eventName)))
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert_rounded),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      enabled: !isEnded,
                      child: GestureDetector(
                        onTap: () {
                          if(!isEnded) {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                EventEditor(
                                  uid: user.uid,
                                  event: widget.event.copy(),
                                  isNew: false,
                                  eventAsset: widget.eventAsset,
                                  refresh: widget.refresh
                                )
                            ));
                          }
                        },
                        child: Text('Edit Event')
                      )
                    ),
                    PopupMenuItem(
                      enabled: !isEnded,
                      child: GestureDetector(
                        onTap: () {
                          if(!isEnded) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Cancel Event'),
                                content: Text('Do you really want to cancel this event?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('NO')
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String result = await _database.cancelEvent(widget.event.eventId, Activity(
                                        heading: 'Event Cancelled',
                                        datetime: DateTime.now().toString(),
                                        body: 'You\'ve cancelled ${widget.event.eventName}',
                                        type: ActivityType.cancelEvent
                                      ));
                                      Navigator.of(context).pop();
                                      if(result == 'SUCCESS') {
                                        final snackBar = SnackBar(
                                          duration: Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          content: Text('Event Cancelled'),
                                          action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                                        );
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Cancel Event'),
                                            content: Text(result),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('OK')
                                              )
                                            ],
                                          )
                                        );
                                      }
                                    },
                                    child: Text('YES')
                                  )
                                ],
                              )
                            );
                          }
                        },
                        child: Text('Cancel Event')
                      )
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          final data = DataManager(
                            uid: user.uid,
                            event: widget.event,
                            participants: participants,
                            datetimes: {for (var user in participants) user.uid: user.datetime}
                          );
                          String result = await data.exportData(widget.event.eventId);
                          if(result == 'SUCCESS') {
                            final snackBar = SnackBar(
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              content: Text('Data Exported'),
                              action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Export Data'),
                                content: Text(result),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK')
                                  )
                                ],
                              )
                            );
                          }
                        },
                        child: Text('Export Data')
                      ),
                    ),
                    PopupMenuItem(
                      enabled: isEnded,
                      child: GestureDetector(
                        onTap: () {
                          if(isEnded) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Archive Event'),
                                content: Text('Archiving event will remove it from your Event list but data will be kept at the database for possible future usage. Do you really want to archive this event?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('NO')
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      String result = await _database.archiveEvent(widget.event.eventId, Activity(
                                        heading: 'Event Archived',
                                        datetime: DateTime.now().toString(),
                                        body: 'You\'ve archived ${widget.event.eventName}',
                                        type: ActivityType.archiveEvent
                                      ));
                                      if(result == 'SUCCESS') {
                                        widget.refresh();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Archive Event'),
                                            content: Text(result),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('OK')
                                              )
                                            ],
                                          )
                                        );
                                      }
                                    },
                                    child: Text('YES')
                                  ),
                                ]
                              )
                            );
                          }
                        },
                        child: Text('Archive Event')
                      ),
                    ),
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
                Statistics(createdAt: DateTime.parse(widget.event.createdAt), conductedAt: widget.event.datetime),
                FutureBuilder(
                  future: _database.interestedUsers(interested.map((interested) => interested.uid).toList()),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      return UserList(users: snapshot.data, type: 'INTERESTED', datetimes: {for (var user in interested) user.uid: user.datetime});
                    } else {
                      return Loading('Loading Interested Data');
                    }
                  }
                ),
                FutureBuilder(
                  future: _database.participantUsers(participants.map((participant) => participant.uid).toList()),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      return UserList(users: snapshot.data, type: 'PARTICIPANT', datetimes: {for (var user in participants) user.uid: user.datetime});
                    } else {
                      return Loading('Loading Participants Data');
                    }
                  }
                )
              ],
            )
          ),
        ),
      );
    } else {
      return Loading('Loading Event Data');
    }
  }
}
