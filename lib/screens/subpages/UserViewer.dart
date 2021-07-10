import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'PhotoViewer.dart';

class UserViewer extends StatelessWidget {
  final AccountData accountData;

  UserViewer({this.accountData});

  int getAge(String birthdayString) {
    int age = 0;
    DateTime birthday = DateTime.parse(birthdayString);
    DateTime today = DateTime.now();

    age = today.year - birthday.year;

    if(DateTime(today.year, today.month, today.day).compareTo(DateTime(birthday.year, birthday.month, birthday.day)) < 0) {
      return age - 1;
    } else {
      return age;
    }
  }

  @override
  Widget build(BuildContext context) {
    final StorageService _storage = StorageService();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Person Viewer'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/subBackground.png'),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: FutureBuilder(
                  future: _storage.getUserId(accountData.uid, accountData.idUri),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoViewer(title: 'User Profile', image: snapshot.data))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: snapshot.data,
                        ),
                      );
                    } else {
                      return ClipRRect(
                        child: Container(
                          color: Colors.white,
                          child: Center(
                            child: SpinKitRotatingPlain(
                              color: theme.accentColor,
                              size: 40
                            ),
                          ),
                        ),
                      );
                    }
                  },
                )
              ),
              Divider(height: 20),
              Expanded(
                flex: 8,
                child: ListView(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person_rounded, color: Colors.white),
                        backgroundColor: theme.accentColor,
                      ),
                      title: Text(accountData.fullName),
                      subtitle: Text(accountData.email),
                      //subtitle: Text(user.email),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.location_on_rounded, color: Colors.white),
                        backgroundColor: theme.accentColor,
                      ),
                      title: Text('Address'),
                      subtitle: Text(accountData.address),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.phone_rounded, color: Colors.white),
                        backgroundColor: theme.accentColor,
                      ),
                      title: Text('Phone'),
                      subtitle: Text(accountData.contact),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.cake_rounded, color: Colors.white),
                        backgroundColor: theme.accentColor,
                      ),
                      title: Text('Age'),
                      subtitle: Text('${getAge(accountData.birthday)}'),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.accessibility_new_rounded, color: Colors.white),
                        backgroundColor: theme.accentColor,
                      ),
                      title: Text('Sex'),
                      subtitle: Text(accountData.sex),
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
