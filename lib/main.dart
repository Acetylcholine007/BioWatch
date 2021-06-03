import 'package:bio_watch/shared/DataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthWrapper.dart';

void main() => runApp(ChangeNotifierProvider(
  create: (context) => DataProvider(),
  child: MaterialApp(
    theme: appTheme,
    home: AuthWrapper()
  ),
));

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF2196F3),
  primaryColorLight: Color(0xFFBBDEFB),
  primaryColorDark: Color(0xFF1976D2),
  accentColor: Color(0xFFFF5722),
  dividerColor: Color(0xFFBDBDBD)
);