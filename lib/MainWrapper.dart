import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/screens/mainpages/AccountPage.dart';
import 'package:bio_watch/screens/mainpages/ActivityPage.dart';
import 'package:bio_watch/screens/mainpages/EventPage.dart';
import 'package:bio_watch/screens/mainpages/HomePage.dart';
import 'package:bio_watch/screens/subpages/EventEditor.dart';
import 'package:bio_watch/screens/subpages/Scanner.dart';
import 'package:flutter/material.dart';
import 'models/User.dart';

class MainWrapper extends StatefulWidget {
  final User user;

  MainWrapper({this.user});

  @override
  _MainWrapperState createState() => _MainWrapperState(user);
}

class _MainWrapperState extends State<MainWrapper> {
  User user;
  int _currentIndex = 0;

  _MainWrapperState(this.user);

  @override
  Widget build(BuildContext context) {
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
              time: '',
              date: '',
              description: '',
              bannerUri: 'assets/events/img1.jpg'
            ), isNew: true))))
          ] : [
            IconButton(icon: Icon(Icons.qr_code_scanner_rounded), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Scanner())))
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
