import 'package:flutter/material.dart';

class TileCard extends StatelessWidget {
  final String eventName;
  final String hostName;
  final String address;
  final String uri;

  TileCard({this.eventName, this.hostName, this.address, this.uri});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 150,
      child: Card(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Text(eventName, style: theme.textTheme.headline6),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(borderRadius: BorderRadius.circular(5), child: SizedBox(height: 100, width: 100, child: Image(image: AssetImage(uri), fit: BoxFit.fitHeight))),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Text(hostName),
                        Text(address)
                      ],
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
