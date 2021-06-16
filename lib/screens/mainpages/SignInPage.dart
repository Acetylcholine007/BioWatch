import 'dart:io';

import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final AccountData user;

  SignInPage({this.user});

  @override
  _SignInPageState createState() => _SignInPageState(user);
}

class _SignInPageState extends State<SignInPage> {
  final imagePicker = ImageManager();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  File userId;
  bool loading = false;
  bool hidePassword = true;
  String error = '';
  String email = '';
  String password = '';
  AccountData user;
  _SignInPageState(this.user);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return loading ? Loading() : GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () async {
                          dynamic result = await imagePicker.showPicker(context);
                          if(result['image'] != null) {
                            if(userId != null)
                              await userId.delete();
                            setState(() {
                              userId = result['image'];
                            });
                          }
                        },
                        child: SizedBox(
                          height: 300,
                          width: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: userId != null ? Image(image: FileImage(userId), fit: BoxFit.fitWidth) : Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: user.fullName,
                      decoration: textFieldDecoration.copyWith(hintText: 'Full Name'),
                      validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                      onChanged: (val) => setState(() => user.fullName = val)
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: email,
                      decoration: textFieldDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter Email' : null,
                      onChanged: (val) => setState(() => email = val)
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: user.accountType,
                            decoration: textFieldDecoration.copyWith(hintText: 'Account Type'),
                            validator: (val) => val.isEmpty ? 'Enter AccountType' : null,
                            onChanged: (val) => setState(() => user.accountType = val),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: password,
                            decoration: textFieldDecoration.copyWith(suffixIcon: IconButton(
                              onPressed: () => setState(() => hidePassword = !hidePassword),
                              icon: Icon(Icons.visibility)
                              ),
                              hintText: 'Password'
                            ),
                            validator: (val) => val.isEmpty ? 'Enter Password' : null,
                            onChanged: (val) => setState(() => password = val),
                            obscureText: hidePassword,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      initialValue: user.address,
                      decoration: textFieldDecoration.copyWith(hintText: 'Permanent Address'),
                      validator: (val) => val.isEmpty ? 'Enter Permanent Address' : null,
                      onChanged: (val) => setState(() => user.address = val)
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: user.contact,
                            decoration: textFieldDecoration.copyWith(hintText: 'Contact No.'),
                            validator: (val) => val.isEmpty ? 'Enter Contact No.' : null,
                            onChanged: (val) => setState(() => user.contact = val)
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DateTimePicker(
                            validator: (val) => val.isEmpty ? 'Enter Birthday' : null,
                            type: DateTimePickerType.date,
                            dateMask: 'MMMM d, yyyy',
                            initialValue: user.birthday,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 5),
                            dateLabelText: 'Birthday',
                            decoration: textFieldDecoration.copyWith(hintText: 'Birthday'),
                            onChanged: (val) => setState(() => user.birthday = val)
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(error, style: TextStyle(color: Colors.red, fontSize: 14))
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      child: Text('CREATE ACCOUNT'),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          String result = await _auth.signIn(user, email, password, userId);
                          if(result != 'SUCCESS') {
                            setState(() {
                              error = result;
                              loading = false;
                            });
                          } else {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: theme.accentColor),
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
