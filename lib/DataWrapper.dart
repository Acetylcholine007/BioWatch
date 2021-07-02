import 'dart:io';

import 'package:bio_watch/MainWrapper.dart';
import 'package:bio_watch/components/Loading.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/models/Resource.dart';
import 'package:bio_watch/models/EventAsset.dart';
import 'package:bio_watch/models/MyEvent.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:bio_watch/shared/ImageManager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DataWrapper extends StatefulWidget {
  @override
  _DataWrapperState createState() => _DataWrapperState();
}

class _DataWrapperState extends State<DataWrapper> {
  void refresh() => setState((){});

  @override
  Widget build(BuildContext context) {
    Future<Resource> getData() async {
      final account = Provider.of<Account>(context);
      final myEventIds = Provider.of<List<String>>(context);
      final DatabaseService _database = DatabaseService(uid: account.uid);
      final ImageManager _imageManager = ImageManager();

      Directory cachePath = await getTemporaryDirectory();
      List<MyEvent> myEvents = myEventIds != null && myEventIds.isNotEmpty ? await _database.myEvents(myEventIds) : <MyEvent>[];
      Map<String, EventAsset> myEventAssets = <String, EventAsset>{};
      if(myEventIds != null) {
        for(int i = 0; i < myEvents.length; i++) {
          myEventAssets[myEvents[i].event.eventId] = _imageManager.getEventAssetFromCache(
            account.uid,
            myEvents[i].event.eventId,
            myEvents[i].event.bannerUri,
            myEvents[i].event.showcaseUris,
            myEvents[i].event.permitUris,
            cachePath
          );
        }
      }

      return Resource(cachePath: cachePath, myEvents: myEvents, myEventAssets: myEventAssets, refresh: refresh);
    }

    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Provider<Resource>.value(
            value: snapshot.data,
            child: MainWrapper()
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
