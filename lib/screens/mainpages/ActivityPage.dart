import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/components/NoActivity.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/screens/subpages/ActivityViewer.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context);
    final activities = Provider.of<List<Activity>>(context);
    final theme = Theme.of(context);
    final DatabaseService _database = DatabaseService(uid: account.uid);

    if(activities != null) {
      activities.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
      return Container(
        child: activities.length != 0 ? ListView.builder(
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityViewer(activity: activities[index]))),
              child: Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(activities[index].id),
                background: Container(
                  color: theme.accentColor
                ),
                onDismissed: (direction) => _database.removeActivity(activities[index].id),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(activities[index].heading[0]),
                  ),
                  title: Text(activities[index].heading),
                  subtitle: Text(activities[index].date),
                ),
              ),
            );
          }
        ) : NoActivity()
      );
    } else {
      return Loading();
    }
  }
}
