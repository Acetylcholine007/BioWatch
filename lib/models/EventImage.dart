import 'package:flutter/material.dart';

class EventImage {
  Image banner;
  List<Image> showcases;
  List<Image> permits;

  EventImage({this.banner, showcases, permits}) {
    this.showcases = showcases != null ? showcases : [];
    this.permits = permits != null ? permits : [];
  }
}