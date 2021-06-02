import 'package:bio_watch/components/TileCard.dart';
import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/screens/subpages/EventViewer.dart';
import 'package:bio_watch/shared/DataProvider.dart';
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
    List<int> eventIds = Provider.of<DataProvider>(context, listen: false).myEvents;
    List<PeopleEvent> events = Provider.of<DataProvider>(context, listen: false).events.where((event) => eventIds.indexOf(event.id) != -1).toList();

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventViewer(event: events[index], callback: null))),
              child: TileCard(
                eventName: events[index].eventName,
                hostName: events[index].hostName,
                address: events[index].address,
                uri: events[index].bannerUri,
              ),
            );
          }
        ),
      )
    );
  }
}
