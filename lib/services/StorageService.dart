import 'dart:io';

import 'package:bio_watch/models/EventAsset.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class StorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Widget loadingBuilder (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null ?
      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
      ),
    );
  }

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
      return Image(image: FileImage(myId), fit: BoxFit.fitHeight, loadingBuilder: loadingBuilder);
    } on FirebaseException catch(e) {
      print(e);
      return Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth);
    }
  }

  Future<Image> getUserId(String uid, String filename) async {
    try {
      String url = await storage.ref('users/$uid/$filename').getDownloadURL();
      return Image(image: NetworkImage(url), fit: BoxFit.fitHeight, loadingBuilder: loadingBuilder);
    } on FirebaseException catch(e) {
      print(e);
      return Image(image: AssetImage('assets/placeholder.jpg'), fit: BoxFit.fitWidth);
    }
  }

  Future<File> getEventBanner(String uid, String eventId, String filename, Directory cachePath) async {
    File eventBanner = await File('${cachePath.path}/$uid/$eventId/$filename').create(recursive: true);
    try {
      await storage.ref('events/$eventId/$filename').writeToFile(eventBanner);
      return eventBanner;
    } on FirebaseException catch(e) {
      print(e);
      return null;
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

  Future<Image> getBannerImage(String eventId, bannerUri) async {
    try {
      return Image.network(await storage.ref('events/$eventId/$bannerUri').getDownloadURL(), fit: BoxFit.cover, loadingBuilder: loadingBuilder);
    } catch(e) {
      print(e);
      return Future(() => Image.asset('assets/noImage.jpg', fit: BoxFit.fitWidth));
    }
  }

  Future<List<Image>> getShowcaseImages(String eventId, List showcaseUris) async {
    List<Image> showcases = [];
    try {
      for(int i = 0; i < showcaseUris.length; i++) {
        showcases.add(Image.network(await storage.ref('events/$eventId/showcases/${showcaseUris[i]}').getDownloadURL(), fit: BoxFit.cover, loadingBuilder: loadingBuilder));
      }
      return showcases.isNotEmpty ? showcases : <Image>[Image.asset('assets/noImage.jpg', fit: BoxFit.cover)];
    } catch(e) {
      print(e);
      return Future(() => <Image>[Image.asset('assets/noImage.jpg', fit: BoxFit.cover)]);
    }
  }

  Future<List<Image>> getPermitImages(String eventId, List permitUris) async {
    List<Image> permits = [];
    try {
      for(int i = 0; i < permitUris.length; i++) {
        permits.add(Image.network(await storage.ref('events/$eventId/permits/${permitUris[i]}').getDownloadURL(), fit: BoxFit.cover, loadingBuilder: loadingBuilder));
      }
      return permits.isNotEmpty ? permits : <Image>[Image.asset('assets/noImage.jpg', fit: BoxFit.cover)];
    } catch(e) {
      print(e);
      return Future(() => <Image>[Image.asset('assets/noImage.jpg', fit: BoxFit.cover)]);
    }
  }

  Future<EventAsset> getEventAsset(String uid, String eventId, String bannerUri, List showcaseUris, List permitUris, Directory cachePath) async {
    try{
      EventAsset eventAsset = EventAsset();

      if(bannerUri != '') {
        File banner = await File('${cachePath.path}/$uid/$eventId/$bannerUri').create(recursive: true);
        await storage.ref('events/$eventId/$bannerUri').writeToFile(banner);
        eventAsset.banner = banner;
      } else {
        eventAsset.banner = null;
      }

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
}