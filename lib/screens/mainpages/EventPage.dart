import 'package:bio_watch/components/BannerCard.dart';
import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/Resource.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/screens/subpages/EventViewer.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String queryName = '';

  @override
  Widget build(BuildContext context) {
    final accountData = Provider.of<AccountData>(context);
    final DatabaseService _database = DatabaseService(uid: accountData.uid);
    final myEvents = Provider.of<List<String>>(context);
    final data = Provider.of<Resource>(context);

    List<PeopleEvent> events = Provider.of<List<PeopleEvent>>(context);

    if(queryName != '') {
      events = events.where((event) => event.eventName.contains(new RegExp(queryName, caseSensitive: false))).toList();
    }

    return events != null && myEvents != null ? Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: queryName,
              decoration: textFieldDecoration.copyWith(suffixIcon: Icon(Icons.search_rounded), hintText: 'Search'),
              onChanged: (val) => setState(() => queryName = val)
            ),
          ),
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (BuildContext context, int index) {
                  return Builder(
                    builder: (context) {
                      Future<String> count = _database.getInterestedCount(events[index].eventId);
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<List<String>>.value(
                          initialData: null,
                          value: DatabaseService(uid: accountData.uid).myEventIds,
                          child: EventViewer(event: events[index], user: accountData, interestedCount: count),
                        ))),
                        child: BannerCard(event: events[index], cachePath: data.cachePath, uid: accountData.uid, interestedCount: count)
                      );
                    },
                  );
                }
              ),
            ),
          ),
        ],
      )
    ) : Loading();
  }
}
