import 'package:flutter/material.dart';

class EventEditor extends StatefulWidget {
  const EventEditor({Key key}) : super(key: key);

  @override
  _EventEditorState createState() => _EventEditorState();
}

class _EventEditorState extends State<EventEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Editor'),
        actions: [

        ],
      ),
      body: Container(

      ),
    );
  }
}
