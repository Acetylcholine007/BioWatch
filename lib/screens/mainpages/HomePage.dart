import 'package:bio_watch/components/NoEvent.dart';
import 'package:bio_watch/components/NoInterest.dart';
import 'package:bio_watch/components/TileCard.dart';
import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/models/User.dart';
import 'package:bio_watch/screens/subpages/EventDashboard.dart';
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
    User user = Provider.of<DataProvider>(context, listen: false).user;
    List<int> eventIds = user.myEvents;
    List<PeopleEvent> events = Provider.of<DataProvider>(context, listen: true).events.where((event) => eventIds.indexOf(event.id) != -1).toList();

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: events.length != 0 ? ListView.builder(
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if(user.accountType == 'USER') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EventViewer(event: events[index], user: user)));
                } else if (user.accountType == 'HOST') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EventDashboard(event: events[index])));
                }
              },
              child: TileCard(
                eventName: events[index].eventName,
                hostName: events[index].hostName,
                address: events[index].address,
                uri: events[index].bannerUri,
              ),
            );
          }
        ) : user.accountType == 'USER' ? NoInterest() : NoEvent(),
      )
    );
  }
}
