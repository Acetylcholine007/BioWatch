import 'dart:io';

import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Data.dart';
import 'package:bio_watch/screens/subpages/AccountEditor.dart';
import 'package:bio_watch/screens/subpages/PhotoViewer.dart';
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

  void refresh() => setState((){});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context);
    final accountData = Provider.of<AccountData>(context);
    final data = Provider.of<Data>(context);
    final theme = Theme.of(context);

    File profile = File('${data.cachePath.path}/${accountData.uid}/id/${accountData.idUri}');

    return FutureBuilder(
      initialData: profile.existsSync() ? Image(image: FileImage(profile), fit: BoxFit.fitHeight) : Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth),
      future: StorageService().getMyId(accountData.uid, accountData.idUri, data.cachePath),
      builder: (context, snapshot) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoViewer(title: 'User Profile', image: snapshot.data))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: snapshot.data
                    ),
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
                        title: Text(accountData.fullName),
                        subtitle: Text(account.email),
                        //subtitle: Text(user.email),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.location_on_rounded),
                        ),
                        title: Text('Address'),
                        subtitle: Text(accountData.address),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.phone_rounded),
                        ),
                        title: Text('Phone'),
                        subtitle: Text(accountData.contact),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.cake_rounded),
                        ),
                        title: Text('Birthday'),
                        subtitle: Text(accountData.birthday),
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
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountEditor(user: accountData, image: snapshot.data, refresh: refresh, cachePath: data.cachePath))),
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
      }
    );
  }
}
