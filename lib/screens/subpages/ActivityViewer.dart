import 'package:bio_watch/models/Activity.dart';
import 'package:flutter/material.dart';

class ActivityViewer extends StatelessWidget {
  final Activity activity;

  ActivityViewer({this.activity});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Viewer'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity.heading, style: theme.textTheme.headline4),
              Text(activity.date, style: theme.textTheme.headline6),
              Divider(),
              Text(activity.body, style: theme.textTheme.bodyText1)
            ],
          ),
        ),
      ),
    );
  }
}
