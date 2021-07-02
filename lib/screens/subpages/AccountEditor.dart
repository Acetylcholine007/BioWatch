import 'dart:io';

import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Enum.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

class AccountEditor extends StatefulWidget {
  final Function refresh;
  final Directory cachePath;
  final AccountData user;
  final Image image;
  final String email;

  AccountEditor({this.user, this.image, this.cachePath, this.refresh, this.email});

  @override
  _AccountEditorState createState() => _AccountEditorState(user, image, email);
}

class _AccountEditorState extends State<AccountEditor> {
  final imagePicker = ImageManager();
  final _formKey = GlobalKey<FormState>();
  File userId;
  Image profile;
  String email;
  AccountData userData;
  String error = '';
  String password = '';
  bool loading = false;
  bool hidePassword = true;
  bool profileChanged = false;
  bool passwordChanged = false;
  bool emailChanged = false;
  bool userDataChanged = false;

  _AccountEditorState(this.userData, this.profile, this.email);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final StorageService _storage = StorageService();
    final DatabaseService _database = DatabaseService(uid: userData.uid);
    final theme = Theme.of(context);

    void saveChanges() async {
      if(_formKey.currentState.validate()) {
        setState(() => loading = true);
        String result1 = passwordChanged ? await _auth.changePassword(password) : 'SUCCESS';
        String result2 = emailChanged ? await _auth.changeEmail(email) : 'SUCCESS';
        String result3 = userDataChanged ? await _database.editAccount(userData, Activity(
          heading: 'Account Edited',
          datetime: DateTime.now().toString(),
          body: 'You\'ve edited your account',
          type: ActivityType.editEvent
        )) : 'SUCCESS';
        String result4 = userId != null && profileChanged ? await _storage.uploadId(userData.uid, userId, widget.cachePath) : 'SUCCESS';
        if(result1 == 'SUCCESS' && result2 == 'SUCCESS' && result3 == 'SUCCESS' && result4 == 'SUCCESS') {
          widget.refresh();
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            content: Text('Account Edited'),
            action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop();
        } else {
          setState(() {
            error = 'Error editing account';
            loading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Edit Account'),
              content: Text('$result1\n$result2\n$result3\n$result4'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK')
                )
              ],
            )
          );
        }
      } else {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          content: Text('Fill up all the fields'),
          action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return loading ? Loading() : GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Account'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: profileChanged || passwordChanged || emailChanged || userDataChanged ? () async {
              return showDialog(context: context, builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Edit Account'),
                  content: Text('Do you want to save your changes?'),
                  actions: [
                    TextButton(onPressed: () async {
                      Navigator.of(context).pop();
                      saveChanges();
                    }, child: Text('Yes')),
                    TextButton(onPressed: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }, child: Text('No'))
                  ],
                );
              });
            } : () => Navigator.of(context).pop(),
          ),
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: GestureDetector(
                              onTap: () async {
                                dynamic result = await imagePicker.showPicker(context);
                                if(result['image'] != null) {
                                  if(userId != null)
                                    await userId.delete();
                                  setState(() {
                                    userId = result['image'];
                                    userData.idUri = userId.path.split('/').last;
                                    profile = Image(image: FileImage(userId), fit: BoxFit.cover);
                                    profileChanged = true;
                                  });
                                }
                              },
                              child: SizedBox(
                                height: 220,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      Positioned.fill(
                                        child: profile == null ? Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth) : profile,
                                      ),
                                      Container(color: Colors.grey[200], padding: EdgeInsets.all(10), child: Text('Valid ID'))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          DateTimePicker(
                            validator: (val) => val.isEmpty ? 'Enter Birthday' : null,
                            type: DateTimePickerType.date,
                            dateMask: 'MMMM d, yyyy',
                            initialValue: userData.birthday,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(DateTime.now().year),
                            dateLabelText: 'Birthday',
                            decoration: textFieldDecoration.copyWith(hintText: 'Birthday'),
                            onChanged: (val) => setState(() {
                              userData.birthday = val;
                              userDataChanged = true;
                            })
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: email,
                            decoration: textFieldDecoration.copyWith(hintText: 'New Email'),
                            validator: (val) => val.isEmpty ? 'Enter Email' : null,
                            onChanged: (val) => setState(() {
                              email = val;
                              emailChanged = true;
                            })
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: password,
                            decoration: textFieldDecoration.copyWith(suffixIcon: IconButton(
                              onPressed: () => setState(() => hidePassword = !hidePassword),
                              icon: Icon(Icons.visibility)
                            ),
                                hintText: 'New Password'
                            ),
                            validator: (val) => val.length < 7 && passwordChanged ? 'Length should be at least 7 characters' : null,
                            onChanged: (val) => setState(() {
                              password = val;
                              passwordChanged = true;
                            }),
                            obscureText: hidePassword,
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            initialValue: userData.contact,
                            decoration: textFieldDecoration.copyWith(hintText: 'Contact No.'),
                            validator: (val) => val.isEmpty ? 'Enter Contact No.' : null,
                            onChanged: (val) => setState(() {
                              userData.contact = val;
                              userDataChanged = true;
                            })
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              child: Text('SAVE CHANGES'),
                              onPressed: saveChanges,
                              style: ElevatedButton.styleFrom(primary: theme.accentColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ),
            );
          }
        ),
      ),
    );
  }
}
