import 'package:bio_watch/DataWrapper.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/screens/mainpages/LoginPage.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key key}) : super(key: key);

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Account>(context);
    
    if(authUser != null) {
      return MultiProvider(
        providers: [
          StreamProvider<AccountData>.value(value: DatabaseService(uid: authUser.uid).user, initialData: null),
          StreamProvider<List<PeopleEvent>>.value(value: DatabaseService(uid: authUser.uid).events, initialData: null),
          StreamProvider<List<Activity>>.value(value: DatabaseService(uid: authUser.uid).activity, initialData: null),
          StreamProvider<List<String>>.value(value: DatabaseService(uid: authUser.uid).myEventIds, initialData: null)
        ],
        child: DataWrapper()
      );
    } else {
      return LoginPage();
    }
  }
}


