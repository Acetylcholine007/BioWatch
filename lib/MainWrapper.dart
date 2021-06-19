import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/EventImage.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/screens/mainpages/AccountPage.dart';
import 'package:bio_watch/screens/mainpages/ActivityPage.dart';
import 'package:bio_watch/screens/mainpages/EventPage.dart';
import 'package:bio_watch/screens/mainpages/HomePage.dart';
import 'package:bio_watch/screens/subpages/EventEditor.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatefulWidget {
  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  Future<String> scanCode() async {
    var result = await BarcodeScanner.scan();
    return result.rawContent;
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context);
    final accountData = Provider.of<AccountData>(context);
    final DatabaseService _database = DatabaseService(uid: account.uid);
    final theme = Theme.of(context);
    final pages = [
      HomePage(),
      ActivityPage(),
      EventPage(),
      AccountPage()
    ];

    return accountData != null ? GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bio Watch'),
          actions: accountData.accountType == 'HOST' ? [
            IconButton(icon: Icon(Icons.add), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventEditor(event: PeopleEvent(
              eventName: '',
              hostName: accountData.fullName,
              address: '',
              time: TimeOfDay.now().format(context).split(' ')[0],
              date: DateTime.now().toString(),
              description: '',
              bannerUri: 'assets/events/img1.jpg',
              showcaseUris: [],
              permitUris: []
            ), isNew: true, eventImage: EventImage()))))
          ] : [
            IconButton(icon: Icon(Icons.qr_code_scanner_rounded), onPressed: () async {
              String eventId = await scanCode();
              _database.joinEvent(eventId);
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
    ) : Loading();
  }
}
