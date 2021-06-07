import 'package:bio_watch/models/Person.dart';
import 'package:bio_watch/screens/subpages/AccountEditor.dart';
import 'package:bio_watch/services/AuthService.dart';
import 'package:bio_watch/shared/DataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context) {
    Person user = Provider.of<DataProvider>(context, listen: false).user;
    final theme = Theme.of(context);

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Placeholder()
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
                    subtitle: Text(user.email),
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
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AccountEditor(user: user))),
                      style: ElevatedButton.styleFrom(primary: theme.accentColor),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('LOG OUT'),
                      onPressed: () async => await _auth.logOut(),
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
}
