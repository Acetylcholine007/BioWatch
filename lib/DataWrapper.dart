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

class DataWrapper extends StatelessWidget {
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
        for(int i = 0; i < myEventIds.length; i++) {
          myEventAssets[myEventIds[i]] = _imageManager.getEventAssetFromCache(
            account.uid, myEventIds[i],
            myEvents[i].event.bannerUri,
            myEvents[i].event.showcaseUris,
            myEvents[i].event.permitUris,
            cachePath
          );
        }
      }

      return Resource(cachePath: cachePath, myEvents: myEvents, myEventAssets: myEventAssets);
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
