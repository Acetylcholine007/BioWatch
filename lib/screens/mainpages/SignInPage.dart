import 'dart:io';

import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/screens/subpages/VerificationPage.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
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
  File userProfile;
  bool isProfileMissing = false;
  bool loading = false;
  bool verifying = false;
  bool hidePassword = true;
  String error = '';
  String email = '';
  String password = '';
  AccountData accountData;
  _SignInPageState(this.accountData);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Builder(
          builder: (context) {
            return loading ? Loading('Signing Up') : verifying ?
            VerificationPage(callback: () {
              final snackBar = SnackBar(
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                content: Text('Account Verified'),
                action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
            }, auth: _auth) :
            SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/preBackground.png'),
                    fit: BoxFit.cover
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: GestureDetector(
                                onTap: () async {
                                  dynamic result = await imagePicker.showPicker(context);
                                  if(result != null && result['image'] != null) {
                                    if(userProfile != null)
                                      await userProfile.delete();
                                    setState(() {
                                      userProfile = result['image'];
                                      accountData.idUri = userProfile.path.split('/').last;
                                    });
                                  }
                                },
                                child: SizedBox(
                                  height: 300,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: isProfileMissing ? Border.all(width: 1, color: Colors.red) : null,
                                      ),
                                      child: Stack(
                                        alignment: AlignmentDirectional.bottomStart,
                                        children: [
                                          Positioned.fill(
                                            child: userProfile != null ? Image(image: FileImage(userProfile), fit: BoxFit.fitWidth) : Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth),
                                          ),
                                          ClipRRect(borderRadius: BorderRadius.only(topRight: Radius.circular(5)), child: Container(color: Colors.grey[200], padding: EdgeInsets.all(10), child: Text('Valid ID')))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              initialValue: accountData.fullName,
                              decoration: textFieldDecoration.copyWith(hintText: 'Full Name'),
                              validator: (val) => val.isEmpty ? 'Enter Full Name' : null,
                              onChanged: (val) => setState(() => accountData.fullName = val)
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
                                  child: DropdownButtonFormField(
                                    value: accountData.accountType ?? 'USER',
                                    decoration: textFieldDecoration.copyWith(
                                      contentPadding: EdgeInsets.fromLTRB(10, 18, 10, 17)
                                    ),
                                    validator: (val) => val.isEmpty ? 'Specify AccountType' : null,
                                    items: [
                                      DropdownMenuItem(value: 'USER', child: Text('USER')),
                                      DropdownMenuItem(value: 'HOST', child: Text('HOST'))
                                    ],
                                    onChanged: (val) => setState(() => accountData.accountType = val),
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
                              initialValue: accountData.address,
                              decoration: textFieldDecoration.copyWith(hintText: 'Permanent Address'),
                              validator: (val) => val.isEmpty ? 'Enter Permanent Address' : null,
                              onChanged: (val) => setState(() => accountData.address = val)
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: accountData.contact,
                              decoration: textFieldDecoration.copyWith(hintText: 'Contact No.'),
                              validator: (val) => val.isNotEmpty ? val.length == 11 ? null : 'Length is not equal to 11 digits' : 'Enter Contact No.',
                              onChanged: (val) => setState(() => accountData.contact = val)
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField(
                                    value: accountData.sex ?? 'Male',
                                    decoration: textFieldDecoration.copyWith(
                                        contentPadding: EdgeInsets.fromLTRB(10, 18, 10, 17)
                                    ),
                                    validator: (val) => val.isEmpty ? 'Specify Sex' : null,
                                    items: [
                                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                                      DropdownMenuItem(value: 'Female', child: Text('Female'))
                                    ],
                                    onChanged: (val) => setState(() => accountData.sex = val)
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: DateTimePicker(
                                    validator: (val) => val.isEmpty ? 'Enter Birthday' : null,
                                    type: DateTimePickerType.date,
                                    dateMask: 'MMMM d, yyyy',
                                    initialValue: accountData.birthday,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(DateTime.now().year - 2),
                                    dateLabelText: 'Birthday',
                                    decoration: textFieldDecoration.copyWith(hintText: 'Birthday'),
                                    onChanged: (val) {
                                      print(val);
                                      setState(() => accountData.birthday = val);
                                    }
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              child: Text('CREATE ACCOUNT'),
                              onPressed: () async {
                                if(_formKey.currentState.validate() && userProfile != null) {
                                  setState(() => loading = true);
                                  String result = await _auth.signIn(accountData, email, password, userProfile);
                                  if(result == 'SUCCESS') {
                                    setState(() {
                                      loading = false;
                                      verifying = true;
                                    });
                                  } else {
                                    setState(() {
                                      error = result;
                                      loading = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Sign In'),
                                        content: Text(error),
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
                                  setState(() => isProfileMissing = userProfile == null);
                                  final snackBar = SnackBar(
                                    duration: Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    content: Text('Fill up all the fields'),
                                    action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
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
