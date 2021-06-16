import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/components/NoInterested.dart';
import 'package:bio_watch/components/NoParticipant.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/screens/subpages/UserViewer.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  final List<String> userIds;
  final String type;

  UserList({this.userIds, this.type});

  @override
  _UserListState createState() => _UserListState(userIds);
}

class _UserListState extends State<UserList> {
  String queryName = '';
  List<String> userIds;

  _UserListState(this.userIds);

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context);
    final DatabaseService _database = DatabaseService(uid: account.uid);

    return userIds != null ? userIds.isNotEmpty ? FutureBuilder(
      future: widget.type == 'INTERESTED' ? _database.interestedUsers(userIds) : _database.participantUsers(userIds),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          List<AccountData> users = snapshot.data;
          print(userIds);
          if(queryName != '') {
            users = users.where((user) => user.fullName.contains(new RegExp(queryName, caseSensitive: false))).toList();
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
                    child: users.length != 0 ? ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserViewer(user: users[index]))),
                          child: ListTile(
                            leading: CircleAvatar(),
                            title: Text(users[index].fullName),
                            subtitle: Text('Joined: '),
                          )
                        );
                      }
                    ) : widget.type == ' INTERESTED' ? NoInterested() : NoParticipant(),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    ) : widget.type == 'INTERESTED' ? NoInterested() : NoParticipant() : Loading();
  }
}
