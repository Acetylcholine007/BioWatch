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
      //TODO: old id removal
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

  Future<Image> getUserId(String uid, String filename) async {
    try {
      String url = await storage.ref('users/$uid/$filename').getDownloadURL();
      return Image(image: NetworkImage(url), fit: BoxFit.fitHeight);
    } on FirebaseException catch(e) {
      print(e);
      return Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth);
    }
  }

  Future<Image> getEventBanner(String uid, String eventId, String filename, Directory cachePath) async {
    File eventBanner = await File('${cachePath.path}/$uid/$eventId/$filename').create(recursive: true);

    try {
      await storage.ref('events/$eventId/$filename').writeToFile(eventBanner);
      return Image(image: FileImage(eventBanner), fit: BoxFit.fitHeight);
    } on FirebaseException catch(e) {
      print(e);
      return Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.cover);
    }
  }

  Future<String> uploadEventAsset(String eventId, File banner, List<File> showcases, List<File> permits) async {
    String result = '';
    try {
      if(banner != null) {
        await storage.ref('events/$eventId/${banner.path.split('/').last}').putFile(banner);
      }
      if(showcases.isNotEmpty) {
        for(int i = 0; i < showcases.length; i++) {
          await storage.ref('events/$eventId/showcases/${showcases[i].path.split('/').last}').putFile(showcases[i]);
        }
      }
      if(permits.isNotEmpty) {
        for(int i = 0; i < permits.length; i++) {
          await storage.ref('events/$eventId/permits/${permits[i].path.split('/').last}').putFile(permits[i]);
        }
      }
      //TODO: old file removal
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
      banner = Image.network(await storage.ref('events/$eventId/$bannerUri').getDownloadURL(), fit: BoxFit.cover);
      for(int i = 0; i < showcaseUris.length; i++) {
        showcases.add(Image.network(await storage.ref('events/$eventId/showcases/${showcaseUris[i]}').getDownloadURL(), fit: BoxFit.cover));
      }
      for(int i = 0; i < permitUris.length; i++) {
        permits.add(Image.network(await storage.ref('events/$eventId/permits/${permitUris[i]}').getDownloadURL(), fit: BoxFit.cover));
      }
      return EventImage(banner: banner, showcases: showcases, permits: permits);
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<EventAsset> getEventAsset(String uid, String eventId, String bannerUri, List showcaseUris, List permitUris, Directory cachePath) async {
    try{
      EventAsset eventAsset = EventAsset();

      File banner = await File('${cachePath.path}/$uid/$eventId/$bannerUri').create(recursive: true);
      await storage.ref('events/$eventId/$bannerUri').writeToFile(banner);
      eventAsset.banner = banner;

      for(int showcaseIndex = 0; showcaseIndex < showcaseUris.length; showcaseIndex++) {
        File showcase = await File('${cachePath.path}/$uid/$eventId/showcases/${showcaseUris[showcaseIndex]}').create(recursive: true);
        await storage.ref('events/$eventId/showcases/${showcaseUris[showcaseIndex]}').writeToFile(showcase);
        eventAsset.showcases.add(showcase);
      }

      for(int permitIndex = 0; permitIndex < permitUris.length; permitIndex++) {
        File permit = await File('${cachePath.path}/$uid/$eventId/permits/${permitUris[permitIndex]}').create(recursive: true);
        await storage.ref('events/$eventId/permits/${permitUris[permitIndex]}').writeToFile(permit);
        eventAsset.permits.add(permit);
      }
      return eventAsset;
    } catch(e) {
      print(e);
      return EventAsset();
    }
  }

  Future<Map<String, EventAsset>> getMyEventAssets(String uid, List<MyEvent> myEvents, Directory cachePath) async {
    Map<String, EventAsset> myEventAssets = <String, EventAsset>{};
    try {
      for(int eventIndex = 0; eventIndex < myEvents.length; eventIndex++) {
        PeopleEvent event = myEvents[eventIndex].event;
        myEventAssets[event.eventId] = EventAsset();

        if(event.bannerUri != '') {
          File banner = await File('${cachePath.path}/$uid/${event.eventId}/${event.bannerUri}').create(recursive: true);
          await storage.ref('events/${event.eventId}/${event.bannerUri}').writeToFile(banner);
          myEventAssets[event.eventId].banner = banner;
        } else {
          myEventAssets[event.eventId].banner = null;
        }

        for(int showcaseIndex = 0; showcaseIndex < event.showcaseUris.length; showcaseIndex++) {
          File showcase = await File('${cachePath.path}/$uid/${event.eventId}/showcases/${event.showcaseUris[showcaseIndex]}').create(recursive: true);
          await storage.ref('events/${event.eventId}/showcases/${event.showcaseUris[showcaseIndex]}').writeToFile(showcase);
          myEventAssets[event.eventId].showcases.add(showcase);
        }

        for(int permitIndex = 0; permitIndex < event.permitUris.length; permitIndex++) {
          File permit = await File('${cachePath.path}/$uid/${event.eventId}/permits/${event.permitUris[permitIndex]}').create(recursive: true);
          await storage.ref('events/${event.eventId}/permits/${event.permitUris[permitIndex]}').writeToFile(permit);
          myEventAssets[event.eventId].permits.add(permit);
        }
      }
      return myEventAssets;
    } catch(e) {
      print(e);
      return <String, EventAsset>{};
    }
  }
}