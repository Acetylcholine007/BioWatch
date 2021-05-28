import 'package:flutter/material.dart';

class AccountEditor extends StatefulWidget {
  const AccountEditor({Key key}) : super(key: key);

  @override
  _AccountEditorState createState() => _AccountEditorState();
}

class _AccountEditorState extends State<AccountEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
      ),
      body: Container(

      ),
    );
  }
}
