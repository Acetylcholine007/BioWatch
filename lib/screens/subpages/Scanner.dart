import 'package:bio_watch/shared/DataProvider.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String eventId = '';

  @override
  Widget build(BuildContext context) {
    Function joinEvent = Provider.of<DataProvider>(context, listen: false).joinEvent;
    String userId = Provider.of<DataProvider>(context, listen: false).userId;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 100),
            TextFormField(
              initialValue: eventId,
              decoration: textFieldDecoration.copyWith(hintText: 'Code'),
              validator: (val) => val.isEmpty ? 'Enter Code' : null,
              onChanged: (val) => setState(() => eventId = val)
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('JOIN'),
              onPressed: () => joinEvent(eventId, userId)),
          ],
        ),
      ),
    );
  }
}
