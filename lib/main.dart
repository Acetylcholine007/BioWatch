import 'package:bio_watch/models/User.dart';
import 'package:bio_watch/screens/mainpages/AccountPage.dart';
import 'package:bio_watch/screens/mainpages/ActivityPage.dart';
import 'package:bio_watch/screens/mainpages/EventPage.dart';
import 'package:bio_watch/screens/mainpages/HomePage.dart';
import 'package:bio_watch/screens/mainpages/LoginPage.dart';
import 'package:bio_watch/screens/mainpages/SignInPage.dart';
import 'package:bio_watch/screens/subpages/Scanner.dart';
import 'package:bio_watch/shared/DataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
  create: (context) => DataProvider(),
  child: MaterialApp(
    theme: appTheme,
    home: App()
  ),
));

class App extends StatefulWidget {
  const App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    int userId = Provider.of<DataProvider>(context, listen: false).user;
    User user = Provider.of<DataProvider>(context, listen: false).users.where((user) => user.id == userId).toList()[0];
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
          actions: user.accountType == 'HOST' ? null : [
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

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF2196F3),
  primaryColorLight: Color(0xFFBBDEFB),
  primaryColorDark: Color(0xFF1976D2),
  accentColor: Color(0xFFFF5722),
  dividerColor: Color(0xFFBDBDBD)
);