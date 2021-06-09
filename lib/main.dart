import 'package:bio_watch/AuthWrapper.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    StreamProvider<Account>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        theme: appTheme,
        home: MyApp()
      ),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthWrapper();
  }
}

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF2196F3),
  primaryColorLight: Color(0xFFBBDEFB),
  primaryColorDark: Color(0xFF1976D2),
  accentColor: Color(0xFFFF5722),
  dividerColor: Color(0xFFBDBDBD)
);