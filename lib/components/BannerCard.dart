import 'dart:io';

import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BannerCard extends StatelessWidget {
  final PeopleEvent event;
  final Directory cachePath;
  final String uid;
  final String interestedCount;

  BannerCard({this.event, this.cachePath, this.uid, this.interestedCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final StorageService _storage = StorageService();
    final File bannerFile = File('${cachePath.path}/$uid/${event.eventId}/${event.bannerUri}');
    final bool bannerExists = bannerFile.existsSync();

    Future<Image> getBannerCache() async => Image(image: FileImage(bannerFile), fit: BoxFit.fitWidth);
    return SizedBox(
      height: 250,
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 12,
                child: event.bannerUri != '' ? FutureBuilder(
                  initialData: bannerExists ?
                    Image(image: FileImage(bannerFile), fit: BoxFit.fitWidth) : Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth),
                  future: bannerExists ?
                    getBannerCache() : _storage.getEventBanner(uid, event.eventId, event.bannerUri, cachePath),
                  builder: (context, snapshot) {
                    return snapshot.data;
                  },
                ) : Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth)
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(flex: 9, child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: Text(event.eventName, style: theme.textTheme.headline6, overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 2, child: Text(dateTimeFormatter.format(DateTime.parse(event.datetime)), overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 2, child: Text(event.address, overflow: TextOverflow.ellipsis))
                        ],
                      )),
                      Expanded(flex: 1, child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$interestedCount\n',
                              style: TextStyle(color: Colors.black)
                            ),
                            WidgetSpan(
                              child: Icon(Icons.bookmark_rounded, color: theme.accentColor),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ),

            ]
          ),
        )
      ),
    );
  }
}
