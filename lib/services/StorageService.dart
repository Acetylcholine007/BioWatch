import 'dart:io';

import 'package:bio_watch/models/EventImage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadId(File file, String filename, String uid) async {
    String result = '';
    try {
      await storage.ref('users/$uid/$filename').putFile(file);
      result = 'SUCCESS';
    } on FirebaseException catch (e) {
      result = e.message;
    }
    return result;
  }

  Future<String> uploadEventShowcase(File file, String filename, String eventId) async {
    String result = '';
    try {
      await storage.ref('events/$eventId/showcase/$filename').putFile(file);
      result = 'SUCCESS';
    } on FirebaseException catch (e) {
      result = e.message;
    }
    return result;
  }

  Future<String> uploadEventPermits(File file, String filename, String eventId) async {
    String result = '';
    try {
      await storage.ref('events/$eventId/permits/$filename').putFile(file);
      result = 'SUCCESS';
    } on FirebaseException catch (e) {
      result = e.message;
    }
    return result;
  }

  Future<Image> getId(String filename, String uid) async {
    String downloadURL = await storage.ref('users/$uid/$filename').getDownloadURL();
    return Image.network(downloadURL);
  }

  Future<Image> getEventShowcase(String filename, String eventId) async {
    String downloadURL = await storage.ref('events/$eventId/showcase/$filename').getDownloadURL();
    return Image.network(downloadURL);
  }

  Future<Image> getEventPermits(String filename, String eventId) async {
    String downloadURL = await storage.ref('events/$eventId/permits/$filename').getDownloadURL();
    return Image.network(downloadURL);
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

  Future<EventImage> getEventAsset(String eventId, String bannerUri, List<String> showcaseUris, List<String> permitUris) async {
    // Image banner;
    // List<Image> showcases;
    // List<Image> permits;
    // banner = Image.network(await storage.ref('events/$eventId/bannerUri').getDownloadURL());
    // for(int i = 0; i < showcaseUris.length; i++) {
    //   showcases.add(Image.network(await storage.ref('events/$eventId/showcases/${showcaseUris[i]}').getDownloadURL()));
    // }
    // for(int i = 0; i < permitUris.length; i++) {
    //   showcases.add(Image.network(await storage.ref('events/$eventId/permitUris/${permitUris[i]}').getDownloadURL()));
    // }
    // return EventAsset(banner: banner, showcases: showcases, permits: permits);
    return EventImage();
  }
}