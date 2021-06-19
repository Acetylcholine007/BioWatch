import 'dart:io';

import 'package:bio_watch/models/EventAsset.dart';
import 'package:bio_watch/models/EventImage.dart';
import 'package:bio_watch/models/MyEvent.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadId(String uid, File file, Directory cachePath) async {
    String result = '';
    Directory path = Directory('${cachePath.path}/$uid/id');
    if(!path.existsSync()) {
      await path.create(recursive: true);
    }
    try {
      await storage.ref('users/$uid/${file.path.split('/').last}').putFile(file);
      result = 'SUCCESS';
    } on FirebaseException catch (e) {
      result = e.message;
    }
    return result;
  }

  Future<Image> getMyId(String uid, String filename, Directory cachePath) async {
    Directory path = Directory('${cachePath.path}/$uid/id');
    if(!path.existsSync()) {
      await path.create(recursive: true);
    }
    File myId = File('${cachePath.path}/$uid/id/$filename');

    try {
      await storage.ref('users/$uid/$filename').writeToFile(myId);
      return Image(image: FileImage(myId), fit: BoxFit.fitHeight);
    } on FirebaseException catch(e) {
      print(e);
      return Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth);
    }
  }

  Future<String> uploadEventAsset(String eventId, File banner, List<File> showcases, List<File> permits) async {
    String result = '';
    try {
      await storage.ref('events/$eventId/${banner.path.split('/').last}').putFile(banner);
      for(int i = 0; i < showcases.length; i++) {
        await storage.ref('events/$eventId/showcases/${showcases[i].path.split('/').last}').putFile(showcases[i]);
      }
      for(int i = 0; i < permits.length; i++) {
        await storage.ref('events/$eventId/permits/${permits[i].path.split('/').last}').putFile(permits[i]);
      }

      result = 'SUCCESS';
    } on FirebaseException catch (e) {
      result = e.message;
    }
    return result;
  }

  Future<EventImage> getEventImage(String eventId, String bannerUri, List showcaseUris, List permitUris) async {
    Image banner;
    List<Image> showcases = [];
    List<Image> permits = [];
    try{
      banner = Image.network(await storage.ref('events/$eventId/$bannerUri').getDownloadURL());
      for(int i = 0; i < showcaseUris.length; i++) {
        showcases.add(Image.network(await storage.ref('events/$eventId/showcases/${showcaseUris[i]}').getDownloadURL()));
      }
      for(int i = 0; i < permitUris.length; i++) {
        permits.add(Image.network(await storage.ref('events/$eventId/permits/${permitUris[i]}').getDownloadURL()));
      }
      return EventImage(banner: banner, showcases: showcases, permits: permits);
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<Map<String, EventAsset>> getMyEventAssets(String uid, List<MyEvent> myEvents, Directory cachePath) async {
    Map<String, EventAsset> myEventAssets = <String, EventAsset>{};
    try {
      for(int eventIndex = 0; eventIndex < myEvents.length; eventIndex++) {
        PeopleEvent event = myEvents[eventIndex].event;
        myEventAssets[event.eventId] = EventAsset();

        File banner = await File('${cachePath.path}/$uid/${event.eventId}/${event.bannerUri}').create(recursive: true);
        await storage.ref('events/${event.eventId}/${event.bannerUri}').writeToFile(banner);
        myEventAssets[event.eventId].banner = banner;

        for(int showcaseIndex = 0; showcaseIndex < event.showcaseUris.length; showcaseIndex++) {
          File showcase = await File('${cachePath.path}/$uid/${event.eventId}/showcases/${event.showcaseUris[showcaseIndex]}').create(recursive: true);
          await storage.ref('events/${event.eventId}/showcases/${event.showcaseUris[showcaseIndex]}').writeToFile(showcase);
          myEventAssets[event.eventId].showcases.add(showcase);
        }

        for(int permitIndex = 0; permitIndex < event.showcaseUris.length; permitIndex++) {
          File permit = await File('${cachePath.path}/$uid/${event.eventId}/permits/${event.permitUris[permitIndex]}').create(recursive: true);
          await storage.ref('events/${event.eventId}/permits/${event.permitUris[permitIndex]}').writeToFile(permit);
          myEventAssets[event.eventId].permits.add(permit);
        }
      }
      return myEventAssets;
    } catch(e) {
      print(e);
      return null;
    }
  }
}