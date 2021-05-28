import 'package:flutter/material.dart';

class EventDashboard extends StatefulWidget {
  const EventDashboard({Key key}) : super(key: key);

  @override
  _EventDashboardState createState() => _EventDashboardState();
}

class _EventDashboardState extends State<EventDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Dashboard'),
        actions: [

        ],
      ),
      body: Container(
        
      ),
    );
  }
}
