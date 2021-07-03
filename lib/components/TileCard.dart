import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';

class TileCard extends StatelessWidget {
  final String eventName;
  final String hostName;
  final String address;
  final DateTime datetime;
  final Image banner;

  TileCard({this.eventName, this.hostName, this.address, this.datetime, this.banner});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 150,
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 2,
                child: banner,
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(eventName, style: theme.textTheme.headline4.copyWith(fontSize: 30), overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(DateTime.now().compareTo(datetime) == 1 ? 'EVENT ENDED' : dateTimeFormatter.format(datetime), style: theme.textTheme.bodyText1, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(address, style: theme.textTheme.bodyText1, overflow: TextOverflow.ellipsis),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(hostName, style: theme.textTheme.bodyText1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
