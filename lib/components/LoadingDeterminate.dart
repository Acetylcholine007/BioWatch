import 'package:bio_watch/models/AppTask.dart';
import 'package:flutter/material.dart';

class LoadingDeterminate extends StatelessWidget {
  final AppTask task;
  final int index;
  final int total;
  LoadingDeterminate(this.task, this.index, this.total);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: (index + 1) / total,
              strokeWidth: 10,
            ),
            SizedBox(height: 50),
            Text(task.heading, style: theme.textTheme.headline6),
            Text(task.content, style: theme.textTheme.bodyText2)
          ],
        ),
      ),
    );
  }
}
