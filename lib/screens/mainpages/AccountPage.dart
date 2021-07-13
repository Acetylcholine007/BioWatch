import 'dart:io';

import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Resource.dart';
import 'package:bio_watch/screens/subpages/AccountEditor.dart';
import 'package:bio_watch/screens/subpages/PhotoViewer.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    final data = Provider.of<Resource>(context);
    final theme = Theme.of(context);

    File profile = File('${data.cachePath.path}/${accountData.uid}/id/${accountData.idUri}');

    Widget initialId() {
      if(accountData.idUri != '') {
        if(profile.existsSync()) {
          return Image(image: FileImage(profile), fit: BoxFit.fitHeight);
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: SpinKitRotatingPlain(
                color: theme.accentColor,
                size: 40
              ),
            ),
          );
        }
      } else {
        return Image.asset('assets/noImage.jpg', fit: BoxFit.fitWidth);
      }
    }

    Future<Image> getId() {
      if(accountData.idUri != '') {
        return StorageService().getMyId(accountData.uid, accountData.idUri, data.cachePath);
      } else {
        return Future(() => Image.asset('assets/noImage.jpg', fit: BoxFit.fitWidth));
      }
    }

    return FutureBuilder<Widget>(
      initialData: initialId(),
      future: getId(),
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mainBackground.png'),
              fit: BoxFit.cover
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
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
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.accentColor,
                            child: Icon(Icons.person_rounded, color: Colors.white),
                          ),
                          title: Text(accountData.fullName),
                          subtitle: Text(account.email),
                          //subtitle: Text(user.email),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.accentColor,
                            child: Icon(Icons.location_on_rounded, color: Colors.white),
                          ),
                          title: Text('Address'),
                          subtitle: Text(accountData.address),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.accentColor,
                            child: Icon(Icons.phone_rounded, color: Colors.white),
                          ),
                          title: Text('Phone'),
                          subtitle: Text(accountData.contact),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.accentColor,
                            child: Icon(Icons.cake_rounded, color: Colors.white),
                          ),
                          title: Text('Birthday'),
                          subtitle: Text(dateFormatter.format(DateTime.parse(accountData.birthday))),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.accentColor,
                            child: Icon(Icons.accessibility_new_rounded, color: Colors.white),
                          ),
                          title: Text('Sex'),
                          subtitle: Text(accountData.sex),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text('EDIT ACCOUNT'),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountEditor(
                                user: accountData.copy(), image: snapshot.data, refresh: refresh, cachePath: data.cachePath, email: account.email
                            ))),
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
