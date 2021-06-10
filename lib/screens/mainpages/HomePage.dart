import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/components/NoEvent.dart';
import 'package:bio_watch/components/NoInterest.dart';
import 'package:bio_watch/components/TileCard.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Interested.dart';
import 'package:bio_watch/models/Participant.dart';
import 'package:bio_watch/screens/subpages/EventDashboard.dart';
import 'package:bio_watch/screens/subpages/EventViewer.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AccountData>(context);
    final eventId = Provider.of<List<String>>(context);
    final DatabaseService _database = DatabaseService(uid: user.uid);

    return eventId != null ? eventId.isNotEmpty ? FutureBuilder(
      future: _database.myEvents(eventId),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: snapshot.data.length != 0 ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      if(user.accountType == 'USER') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<List<String>>.value(
                          initialData: null,
                          value: DatabaseService(uid: user.uid).myEventIds,
                          child: EventViewer(event: snapshot.data[index].event, user: user)))
                        );
                      } else if (user.accountType == 'HOST') {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MultiProvider(
                          providers: [
                            StreamProvider<List<Interested>>.value(value: DatabaseService(uid: user.uid).interestedUserIds(snapshot.data[index].event.eventId), initialData: null),
                            StreamProvider<List<Participant>>.value(value: DatabaseService(uid: user.uid).participantUserIds(snapshot.data[index].event.eventId), initialData: null)
                          ],
                          child: EventDashboard(event: snapshot.data[index].event)))
                        );
                      }
                    },
                    child: TileCard(
                      eventName: snapshot.data[index].event.eventName,
                      hostName: snapshot.data[index].event.hostName,
                      address: snapshot.data[index].event.address,
                      uri: snapshot.data[index].event.bannerUri,
                    ),
                  );
                }
              ) : user.accountType == 'USER' ? NoInterest() : NoEvent(),
            )
          );
        } else {
          return Loading();
        }
      }
    ) : user.accountType == 'USER' ? NoInterest() : NoEvent() : Loading();
  }
}
