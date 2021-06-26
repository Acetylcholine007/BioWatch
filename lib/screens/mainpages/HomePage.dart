import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/components/NoEvent.dart';
import 'package:bio_watch/components/NoInterest.dart';
import 'package:bio_watch/components/TileCard.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Resource.dart';
import 'package:bio_watch/models/Interested.dart';
import 'package:bio_watch/models/Participant.dart';
import 'package:bio_watch/screens/subpages/EventDashboard.dart';
import 'package:bio_watch/screens/subpages/EventViewer.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storage = StorageService();

  void refresh() => setState((){});

  @override
  Widget build(BuildContext context) {
    final accountData = Provider.of<AccountData>(context);
    final myEventIds = Provider.of<List<String>>(context);
    final data = Provider.of<Resource>(context);

    return myEventIds != null ? myEventIds.isNotEmpty ? FutureBuilder(
      initialData: data.myEventAssets,
      future: _storage.getMyEventAssets(accountData.uid, data.myEvents, data.cachePath),
      builder: (context, snapshot) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: data.myEvents.length != 0 ? ListView.builder(
              itemCount: data.myEvents.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if(accountData.accountType == 'USER') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<List<String>>.value(
                        initialData: null,
                        value: DatabaseService(uid: accountData.uid).myEventIds,
                        child: FutureBuilder(
                          initialData: snapshot.data[data.myEvents[index].event.eventId].toEventImage(),
                          future: _storage.getEventImage(data.myEvents[index].event.eventId, data.myEvents[index].event.bannerUri, data.myEvents[index].event.showcaseUris, data.myEvents[index].event.permitUris),
                          builder: (context, imageSnapshot) {
                            print('DONE');
                            return EventViewer(event: data.myEvents[index].event, user: accountData, eventImage: imageSnapshot.data);
                          }
                        )))
                      );
                    } else if (accountData.accountType == 'HOST') {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MultiProvider(
                        providers: [
                          StreamProvider<List<Interested>>.value(value: DatabaseService(uid: accountData.uid).interestedUserIds(data.myEvents[index].event.eventId), initialData: null),
                          StreamProvider<List<Participant>>.value(value: DatabaseService(uid: accountData.uid).participantUserIds(data.myEvents[index].event.eventId), initialData: null)
                        ],
                        child: EventDashboard(event: data.myEvents[index].event, refresh: refresh, eventAsset: snapshot.data[data.myEvents[index].event.eventId])))
                      );
                    }
                  },
                  child: TileCard(
                    eventName: data.myEvents[index].event.eventName,
                    hostName: data.myEvents[index].event.hostName,
                    address: data.myEvents[index].event.address,
                    banner: snapshot.data != null && snapshot.data[data.myEvents[index].event.eventId] != null
                      && snapshot.data[data.myEvents[index].event.eventId].banner != null
                      && snapshot.data[data.myEvents[index].event.eventId].banner.existsSync() ?
                      Image(image: FileImage(snapshot.data[data.myEvents[index].event.eventId].banner), fit: BoxFit.cover) :
                      Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.cover),
                  ),
                );
              }
            ) : accountData.accountType == 'USER' ? NoInterest() : NoEvent(),
          )
        );
      },
    ) : accountData.accountType == 'USER' ? NoInterest() : NoEvent() : Loading();
  }
}
