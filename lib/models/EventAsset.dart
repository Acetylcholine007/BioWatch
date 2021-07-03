import 'dart:io';

import 'package:bio_watch/models/EventImage.dart';
import 'package:flutter/material.dart';

class EventAsset {
  File banner;
  List<File> showcases;
  List<File> permits;

  EventAsset({this.banner, showcases, permits}) {
    this.showcases = showcases != null ? showcases : [];
    this.permits = permits != null ? permits : [];
  }

  EventImage toEventImage() {
    Image bannerImage = banner != null ? Image(image: FileImage(banner), fit: BoxFit.fitWidth) : Image.asset('assets/placeholder.jpg', fit: BoxFit.fitWidth);
    List<Image> showcaseImages = showcases.map((showcase) => Image(image: FileImage(showcase), fit: BoxFit.fitWidth)).toList();
    List<Image> permitImages = permits.map((permit) => Image(image: FileImage(permit), fit: BoxFit.fitWidth)).toList();

    return EventImage(banner: bannerImage, showcases: showcaseImages, permits: permitImages);
  }

  bool hasMissing() {
    bool isIncomplete = false;

    if(banner != null && !banner.existsSync()) return true;

    for(int i = 0; i < showcases.length; i++) {
      if(!showcases[i].existsSync()) return true;
    }

    for(int i = 0; i < permits.length; i++) {
      if(!permits[i].existsSync()) return true;
    }

    return isIncomplete;
  }
}