import 'dart:io';

import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/screens/subpages/AccountEditor.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File userId;
  final imagePicker = ImageManager();
  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AccountData>(context);
    final theme = Theme.of(context);

    return FutureBuilder(
      future: StorageService().getId('${user.uid}.png', user.uid),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: snapshot.data != null ? snapshot.data : Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth)
                    )
                  ),
                  Divider(),
                  Expanded(
                    flex: 8,
                    child: ListView(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person_rounded),
                          ),
                          title: Text(user.fullName),
                          //subtitle: Text(user.email),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.location_on_rounded),
                          ),
                          title: Text('Address'),
                          subtitle: Text(user.address),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.phone_rounded),
                          ),
                          title: Text('Phone'),
                          subtitle: Text(user.contact),
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.cake_rounded),
                          ),
                          title: Text('Birthday'),
                          subtitle: Text(user.birthday),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text('EDIT ACCOUNT'),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountEditor(user: user, image: snapshot.data))),
                            style: ElevatedButton.styleFrom(primary: theme.accentColor),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            child: Text('LOG OUT'),
                            onPressed: () => _auth.logOut(),
                            style: ElevatedButton.styleFrom(primary: theme.accentColor),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
