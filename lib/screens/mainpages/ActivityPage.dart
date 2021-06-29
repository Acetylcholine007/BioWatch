import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/components/NoActivity.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Enum.dart';
import 'package:bio_watch/screens/subpages/ActivityViewer.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/shared/decorations.dart';
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
    final Map<ActivityType, IconData> avatars = {
      ActivityType.editAccount: Icons.person_add_rounded,
      ActivityType.createEvent: Icons.event_rounded,
      ActivityType.editEvent: Icons.event_available_rounded,
      ActivityType.cancelEvent: Icons.event_busy_rounded,
      ActivityType.joinEvent: Icons.directions_walk_rounded,
      ActivityType.exportData: Icons.send_rounded
    };

    if(activities != null) {
      activities.sort((a, b) => DateTime.parse(b.datetime).compareTo(DateTime.parse(a.datetime)));
      return Container(
        child: activities.length != 0 ? ListView.separated(
          separatorBuilder: (context, index) => Divider(),
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
                    child: Icon(avatars[activities[index].type]),
                  ),
                  title: Text(activities[index].heading),
                  subtitle: Text(dateTimeFormatter.format(DateTime.parse(activities[index].datetime))),
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
