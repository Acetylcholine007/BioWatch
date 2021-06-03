import 'package:bio_watch/MainWrapper.dart';
import 'package:bio_watch/screens/mainpages/LoginPage.dart';
import 'package:bio_watch/shared/DataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/User.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<DataProvider>(context, listen: true).user;
    if(user != null) {
      return MainWrapper(user: user);
    } else {
      return LoginPage();
    }
  }
}
