import 'dart:io';

import 'EventAsset.dart';
import 'MyEvent.dart';

class Data {
  Directory cachePath;
  List<MyEvent> myEvents;
  Map<String, EventAsset> myEventAssets;

  Data({this.cachePath, this.myEvents, this.myEventAssets});
}