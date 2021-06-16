import 'dart:io';

import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';

class AccountEditor extends StatefulWidget {
  final AccountData user;
  final Image image;

  AccountEditor({this.user, this.image});

  @override
  _AccountEditorState createState() => _AccountEditorState(user.copy(), image);
}

class _AccountEditorState extends State<AccountEditor> {
  final imagePicker = ImageManager();
  final _formKey = GlobalKey<FormState>();
  File userId;
  Image profile;
  AccountData userData;
  String error = '';
  String email = '';
  String password = '';
  bool loading = false;
  bool showPassword = true;

  _AccountEditorState(this.userData, this.profile);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final StorageService _storage = StorageService();
    final DatabaseService _database = DatabaseService(uid: userData.uid);
    final theme = Theme.of(context);

    return loading ? Loading() : GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Account'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () async {
                        dynamic result = await imagePicker.showPicker(context);
                        if(result['image'] != null) {
                          if(userId != null)
                            await userId.delete();
                          setState(() {
                            userId = result['image'];
                            profile = Image(image: FileImage(userId), fit: BoxFit.fitWidth);
                          });
                        }
                      },
                      child: SizedBox(
                        height: 200,
                        width: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: profile == null ? Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth) : profile
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    initialValue: email,
                    decoration: textFieldDecoration.copyWith(hintText: 'New Email'),
                    validator: (val) => val.isEmpty ? 'Enter Email' : null,
                    onChanged: (val) => setState(() => email = val)
                  ),
                  TextFormField(
                    initialValue: password,
                    decoration: textFieldDecoration.copyWith(suffixIcon: IconButton(
                      onPressed: () => setState(() => showPassword = !showPassword),
                      icon: Icon(Icons.visibility)
                    ),
                      hintText: 'New Password'
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Password' : null,
                    onChanged: (val) => setState(() => password = val),
                    obscureText: showPassword,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: userData.contact,
                    decoration: textFieldDecoration.copyWith(hintText: 'Contact No.'),
                    validator: (val) => val.isEmpty ? 'Enter Contact No.' : null,
                    onChanged: (val) => setState(() => userData.contact = val)
                  ),
                  Text(error, style: TextStyle(color: Colors.red, fontSize: 14)),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Text('SAVE CHANGES'),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        String result1 = await _auth.changePassword(password);
                        String result2 = await _auth.changeEmail(email);
                        String result3 = await _database.editAccount(userData);
                        String result4 = userId != null ? await _storage.uploadId(userId, '${userData.uid}.${userId.path.split('.').last}', userData.uid) : 'SUCCESS';
                        if(result1 == 'SUCCESS' && result2 == 'SUCCESS' && result3 == 'SUCCESS' && result4 == 'SUCCESS') {
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            error = '1.$result1 2.$result2 3.$result3 4.$result4';
                            loading = false;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: theme.accentColor),
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
