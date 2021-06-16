import 'package:bio_watch/components/BannerCard.dart';
import 'package:bio_watch/components/Loading.dart';
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
    final user = Provider.of<AccountData>(context);
    final myEvents = Provider.of<List<String>>(context);
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
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<List<String>>.value(
                      initialData: null,
                      value: DatabaseService(uid: user.uid).myEventIds,
                      child: FutureBuilder(
                        //TODO: Implement image fetching
                        future: null,
                        builder: (context, snapshot) {
                          if(/*snapshot.connectionState == ConnectionState.done*/ true) {
                            return EventViewer(event: events[index], user: user, eventImage: snapshot.data);
                          } else {
                            return Loading();
                          }
                        }
                      )
                    ))),
                    child: BannerCard(event: events[index])
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
