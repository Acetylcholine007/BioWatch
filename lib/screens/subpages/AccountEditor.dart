import 'package:bio_watch/models/User.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';

class AccountEditor extends StatefulWidget {
  final User user;

  AccountEditor({this.user});

  @override
  _AccountEditorState createState() => _AccountEditorState(user);
}

class _AccountEditorState extends State<AccountEditor> {
  User user;
  bool showPassword = true;

  _AccountEditorState(this.user);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Account'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Placeholder(),
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
                    initialValue: user.email,
                    decoration: textFieldDecoration.copyWith(hintText: 'Email'),
                    validator: (val) => val.isEmpty ? 'Enter Email' : null,
                    onChanged: (val) => setState(() => user.email = val)
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: user.password,
                    decoration: textFieldDecoration.copyWith(suffixIcon: IconButton(
                      onPressed: () => setState(() => showPassword = !showPassword),
                      icon: Icon(Icons.visibility)
                    ),
                      hintText: 'Password'
                    ),
                    validator: (val) => val.isEmpty ? 'Enter Password' : null,
                    onChanged: (val) => setState(() => user.password = val),
                    obscureText: showPassword,
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
                        child: TextFormField(
                            initialValue: user.birthday,
                            decoration: textFieldDecoration.copyWith(hintText: 'Birthday'),
                            validator: (val) => val.isEmpty ? 'Enter Birthday' : null,
                            onChanged: (val) => setState(() => user.birthday = val)
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    child: Text('SAVE CHANGES'),
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(primary: theme.accentColor),
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
