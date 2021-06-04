import 'package:flutter/material.dart';

class NoParticipant extends StatelessWidget {
  const NoParticipant({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Participant', style: theme.textTheme.headline4),
            SizedBox(height: 20),
            Text('No interested user had joined yet', style: theme.textTheme.bodyText2)
          ],
        ),
      ),
    );
  }
}
