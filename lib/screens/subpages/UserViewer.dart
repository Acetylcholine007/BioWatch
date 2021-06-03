import 'package:bio_watch/models/User.dart';
import 'package:flutter/material.dart';

class UserViewer extends StatelessWidget {
  final User user;

  UserViewer({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Person Viewer'),
      ),
      body: Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
