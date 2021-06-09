import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  final List<String> userIds;
  final String type;

  UserList({this.userIds, this.type});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  String queryName = '';

  @override
  Widget build(BuildContext context) {
    //List<Person> users = Provider.of<DataProvider>(context, listen: false).users.where((user) => widget.userIds.indexOf(user.id) != -1).toList();
    if(queryName != '') {
     //users = users.where((user) => user.fullName.contains(new RegExp(queryName, caseSensitive: false))).toList();
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
          // Expanded(
          //   flex: 11,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: users.length != 0 ? ListView.builder(
          //       itemCount: users.length,
          //       itemBuilder: (BuildContext context, int index){
          //         return GestureDetector(
          //           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserViewer(user: users[index]))),
          //           child: ListTile(
          //             leading: CircleAvatar(),
          //             title: Text(users[index].fullName),
          //             subtitle: Text('Joined: '),
          //           )
          //         );
          //       }
          //     ) : widget.type == ' INTERESTED' ? NoInterested() : NoParticipant(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
