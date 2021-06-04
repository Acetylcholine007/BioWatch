import 'package:flutter/material.dart';

class NoActivity extends StatelessWidget {
  const NoActivity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Activity', style: theme.textTheme.headline4),
            SizedBox(height: 20),
            Text('You have not taken any actions yet', style: theme.textTheme.bodyText2)
          ],
        ),
      ),
    );
  }
}
