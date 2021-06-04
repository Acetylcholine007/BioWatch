import 'package:flutter/material.dart';

class NoInterested extends StatelessWidget {
  const NoInterested({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No Interested', style: theme.textTheme.headline4),
            SizedBox(height: 20),
            Text('No user is taking interest yet', style: theme.textTheme.bodyText2)
          ],
        ),
      ),
    );
  }
}
