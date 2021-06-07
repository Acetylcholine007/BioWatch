import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/screens/mainpages/AccountPage.dart';
import 'package:bio_watch/screens/mainpages/ActivityPage.dart';
import 'package:bio_watch/screens/mainpages/EventPage.dart';
import 'package:bio_watch/screens/mainpages/HomePage.dart';
import 'package:bio_watch/screens/subpages/EventEditor.dart';
import 'package:bio_watch/shared/DataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/Person.dart';

class MainWrapper extends StatefulWidget {
  final Person user;

  MainWrapper({this.user});

  @override
  _MainWrapperState createState() => _MainWrapperState(user);
}

class _MainWrapperState extends State<MainWrapper> {
  Person user;
  int _currentIndex = 0;

  _MainWrapperState(this.user);

  Future<String> scanCode() async {
    var result = await BarcodeScanner.scan();

    print(result.type); // The result type (barcode, cancelled, failed)
    print(result.rawContent); // The barcode content
    print(result.format); // The barcode format (as enum)
    print(result.formatNote); // If a unknown format was scanned this field contains a note
    return result.rawContent;
  }

  @override
  Widget build(BuildContext context) {
    Function joinEvent = Provider.of<DataProvider>(context, listen: false).joinEvent;
    String userId = Provider.of<DataProvider>(context, listen: false).userId;
    final theme = Theme.of(context);
    final pages = [
      HomePage(),
      ActivityPage(),
      EventPage(),
      AccountPage()
    ];

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bio Watch'),
          actions: user.accountType == 'HOST' ? [
            IconButton(icon: Icon(Icons.add), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventEditor(event: PeopleEvent(
              eventName: '',
              hostName: user.fullName,
              address: '',
              time: TimeOfDay.now().format(context).split(' ')[0],
              date: DateTime.now().toString(),
              description: '',
              bannerUri: 'assets/events/img1.jpg'
            ), isNew: true))))
          ] : [
            IconButton(icon: Icon(Icons.qr_code_scanner_rounded), onPressed: () async {
              String eventId = await scanCode();
              joinEvent(eventId, userId);
            })
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: theme.primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          currentIndex: _currentIndex,
          onTap: (value) => setState(() => _currentIndex = value),
          items: [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Activity',
              icon: Icon(Icons.schedule_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Events',
              icon: Icon(Icons.flag_rounded),
            ),
            BottomNavigationBarItem(
              label: 'Me',
              icon: Icon(Icons.person_rounded),
            ),
          ],
        ),
        body: Container(
            child: pages[_currentIndex]
        )
      ),
    );
  }
}
