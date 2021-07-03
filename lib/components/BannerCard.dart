import 'dart:io';

import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BannerCard extends StatelessWidget {
  final PeopleEvent event;
  final Directory cachePath;
  final String uid;
  final Future<String> interestedCount;

  BannerCard({this.event, this.cachePath, this.uid, this.interestedCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final StorageService _storage = StorageService();
    final File bannerFile = File('${cachePath.path}/$uid/${event.eventId}/${event.bannerUri}');
    final bool bannerExists = bannerFile.existsSync();

    Widget initialBanner() {
      if(event.bannerUri != '') {
        return Container(
          color: Colors.white,
          child: Center(
            child: SpinKitRotatingPlain(
              color: theme.accentColor,
              size: 40
            ),
          ),
        );
      } else {
        return Image.asset('assets/placeholder.jpg', fit: BoxFit.fitWidth);
      }
    }

    Future<Image> getBanner() async {
      if(event.bannerUri != '') {
        if(bannerExists) {
          return Future(() => Image(image: FileImage(bannerFile), fit: BoxFit.cover));
        } else {
          File banner = await _storage.getEventBanner(uid, event.eventId, event.bannerUri, cachePath);
          return Image.file(banner, fit: BoxFit.cover);
        }
      } else {
        return Future(() => Image.asset('assets/placeholder.jpg', fit: BoxFit.fitWidth));
      }
    }

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
                child: FutureBuilder<Widget>(
                  initialData: initialBanner(),
                  future: getBanner(),
                  builder: (context, snapshot) {
                    return snapshot.data;
                  },
                )
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
                          Expanded(flex: 2, child: Text(dateTimeFormatter.format(event.datetime), overflow: TextOverflow.ellipsis)),
                          Expanded(flex: 2, child: Text(event.address, overflow: TextOverflow.ellipsis))
                        ],
                      )),
                      Expanded(flex: 1,
                        child: FutureBuilder(
                          initialData: '',
                          future: interestedCount,
                          builder: (context, snapshot) {
                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${snapshot.data}\n',
                                    style: TextStyle(color: Colors.black)
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.bookmark_rounded, color: theme.accentColor),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ),
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
