import 'dart:io';

import 'EventAsset.dart';
import 'MyEvent.dart';

class Resource {
  Directory cachePath;
  List<MyEvent> myEvents;
  Map<String, EventAsset> myEventAssets;
  Function refresh;

  Resource({this.cachePath, this.myEvents, this.myEventAssets, this.refresh});
}