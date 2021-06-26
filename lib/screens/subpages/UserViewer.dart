import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:flutter/material.dart';

import 'PhotoViewer.dart';

class UserViewer extends StatelessWidget {
  final AccountData user;

  UserViewer({this.user});

  int getAge(String birthdayString) {
    int age = 0;
    DateTime birthday = DateTime.parse(birthdayString);
    DateTime today = DateTime.now();

    print(birthday.year);
    age = today.year - birthday.year;

    return today.month >= birthday.month && today.day >= birthday.day ? age : age - 1;
  }

  @override
  Widget build(BuildContext context) {
    final StorageService _storage = StorageService();

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
                child: FutureBuilder(
                  future: _storage.getUserId(user.uid, user.idUri),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoViewer(title: 'User Profile', image: snapshot.data))),
                        child: snapshot.data,
                      );
                    } else {
                      return Loading();
                    }
                  },
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
                      title: Text('Age'),
                      subtitle: Text('${getAge(user.birthday)}'),
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
