import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:flutter/material.dart';

class BannerCard extends StatelessWidget {
  final PeopleEvent event;

  BannerCard({this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 200,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(flex: 6, child: Image(image: AssetImage(event.bannerUri), fit: BoxFit.cover)),
            Expanded(flex: 1, child: Text(event.eventName, style: theme.textTheme.headline6)),
            Expanded(flex: 1, child: Text(event.hostName)),
            Expanded(flex: 1, child: Text(event.address))
          ]
        )
      ),
    );
  }
}
