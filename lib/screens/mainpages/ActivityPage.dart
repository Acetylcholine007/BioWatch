import 'package:bio_watch/components/NoActivity.dart';
import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/screens/subpages/ActivityViewer.dart';
import 'package:bio_watch/shared/DataProvider.dart';
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
    List<Activity> activities = Provider.of<DataProvider>(context, listen: false).user.activities;
    
    return Container(
      child: activities.length != 0 ? ListView.builder(
        itemCount: activities.length,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityViewer(activity: activities[index]))),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(activities[index].heading[0]),
              ),
              title: Text(activities[index].heading),
              subtitle: Text(activities[index].date),
            ),
          );
        }
      ) : NoActivity()
    );
  }
}
