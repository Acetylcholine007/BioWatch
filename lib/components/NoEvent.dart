import 'package:flutter/material.dart';

class NoEvent extends StatelessWidget {
  const NoEvent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Events', style: theme.textTheme.headline4),
            SizedBox(height: 20),
            Text('Tap plus button to create an event', style: theme.textTheme.bodyText2)
          ],
        ),
      ),
    );
  }
}
