import 'package:flutter/material.dart';

class EventViewer extends StatefulWidget {
  const EventViewer({Key key}) : super(key: key);

  @override
  _EventViewerState createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
        actions: [

        ],
      ),
      body: Container(

      ),
    );
  }
}
