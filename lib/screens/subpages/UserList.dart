import 'package:bio_watch/components/NoInterested.dart';
import 'package:bio_watch/components/NoParticipant.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/screens/subpages/UserViewer.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  final List<AccountData> users;
  final String type;
  final Map<String, String> datetimes;

  UserList({this.users, this.type, this.datetimes});

  @override
  _UserListState createState() {
    List<AccountData> usersCopy = users;
    usersCopy.sort((a, b) => DateTime.parse(datetimes[b.uid]).compareTo(DateTime.parse(datetimes[a.uid])));
    return _UserListState(usersCopy);
  }
}

class _UserListState extends State<UserList> {
  String queryName = '';
  List<AccountData> users;
  List<AccountData> usersLocal;

  _UserListState(this.users);

  @override
  Widget build(BuildContext context) {
    usersLocal = widget.users;
    if(queryName != '') {
      usersLocal = widget.users.where((user) => user.fullName.contains(new RegExp(queryName, caseSensitive: false))).toList();
    }
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              initialValue: queryName,
              decoration: textFieldDecoration.copyWith(suffixIcon: Icon(Icons.search_rounded), hintText: 'Search'),
              onChanged: (val) => setState(() => queryName = val)
            ),
          ),
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: usersLocal.length != 0 ? ListView.builder(
                itemCount: usersLocal.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserViewer(accountData: usersLocal[index]))),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(usersLocal[index].fullName[0].toUpperCase())),
                      title: Text(usersLocal[index].fullName),
                      subtitle: Text(dateTimeFormatter.format(DateTime.parse(widget.datetimes[usersLocal[index].uid]))),
                    )
                  );
                }
              ) : widget.type == 'INTERESTED' ? NoInterested() : NoParticipant(),
            ),
          ),
        ],
      ),
    );
  }
}