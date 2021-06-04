import 'dart:math';

import 'package:bio_watch/models/User.dart';
import 'package:bio_watch/screens/mainpages/SignInPage.dart';
import 'package:bio_watch/shared/DataProvider.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    Function login = Provider.of<DataProvider>(context, listen: true).login;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bio Watch Login'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100),
                  Center(child: Text('Biowatch', style: theme.textTheme.headline2)),
                  Center(child: Text('Keep events tracked and safe with Biowatch', style: theme.textTheme.bodyText2)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: email,
                      decoration: textFieldDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter Email' : null,
                      onChanged: (val) => setState(() => email = val)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      initialValue: password,
                      decoration: textFieldDecoration.copyWith(suffixIcon: IconButton(
                        onPressed: () => setState(() => showPassword = !showPassword),
                        icon: Icon(Icons.visibility)
                        ),
                        hintText: 'Password'
                      ),
                      validator: (val) => val.isEmpty ? 'Enter Password' : null,
                      onChanged: (val) => setState(() => password = val),
                      obscureText: showPassword,
                    ),
                  ),
                  ElevatedButton(
                    child: Text('LOG IN'),
                    onPressed: () {
                      bool result = login(email, password);
                      if(result) {
                        //Navigator.of(context).pop();
                        print('success');
                      } else {
                        print('error');
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: theme.accentColor)
                  ),
                  Divider(),
                  ElevatedButton(
                    child: Text('CREATE ACCOUNT'),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage(user: User(
                      id: Random().nextInt(100),
                      fullName: '',
                      password: '',
                      email: '',
                      accountType: '',
                      address: '',
                      contact: '',
                      birthday: '',
                      myEvents: [],
                      activities: []
                    )))),
                    style: ElevatedButton.styleFrom(primary: theme.accentColor),
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
