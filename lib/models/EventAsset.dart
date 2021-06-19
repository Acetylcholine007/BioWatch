import 'dart:io';

class EventAsset {
  File banner;
  List<File> showcases;
  List<File> permits;

  EventAsset({this.banner, showcases, permits}) {
    this.showcases = showcases != null ? showcases : [];
    this.permits = permits != null ? permits : [];
  }
}