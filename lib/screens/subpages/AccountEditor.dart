import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';

class AccountEditor extends StatefulWidget {
  final AccountData user;

  AccountEditor({this.user});

  @override
  _AccountEditorState createState() => _AccountEditorState(user.copy());
}

class _AccountEditorState extends State<AccountEditor> {
  final _formKey = GlobalKey<FormState>();
  AccountData userData;
  String error = '';
  String email = '';
  String password = '';
  bool loading = false;
  bool showPassword = true;

  _AccountEditorState(this.userData);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
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
                  SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Placeholder(),
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
                        if(result1 == 'SUCCESS' || result2 == 'SUCCESS' || result3 == 'SUCCESS') {
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            error = result1 + result2 + result3;
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
