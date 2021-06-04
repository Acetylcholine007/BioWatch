import 'package:flutter/material.dart';

class NoInterest extends StatelessWidget {
  const NoInterest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Interests', style: theme.textTheme.headline4),
            SizedBox(height: 20),
            Text('Go to Events Page to view available events', style: theme.textTheme.bodyText2)
          ],
        ),
      ),
    );
  }
}
