import 'package:bio_watch/components/BannerCard.dart';
import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/screens/subpages/EventViewer.dart';
import 'package:bio_watch/shared/DataProvider.dart';
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
    List<PeopleEvent> events = Provider.of<DataProvider>(context, listen: false).events;

    return Container(
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
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventViewer(event: events[index], callback: null))),
                    child: BannerCard(event: events[index])
                  );
                }
              ),
            ),
          ),
        ],
      )
    );
  }
}
