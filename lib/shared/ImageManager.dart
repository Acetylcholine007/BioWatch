import 'dart:io';

import 'package:bio_watch/models/EventAsset.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageManager {
  final picker = ImagePicker();
  File _image;

  _imgFromCamera() async {
    final image = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50
    );

    _image = File(image.path);
  }

  _imgFromGallery() async {
    final image = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    _image = File(image.path);
  }

  Future<dynamic> showPicker(context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text('Photo Library'),
                  onTap: () async {
                    await _imgFromGallery();
                    Navigator.pop(context, {'image': _image});
                  }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () async {
                    await _imgFromCamera();
                    Navigator.pop(context, {'image': _image});
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // Future<String> saveIdToCache(String uid, File file) async {
  //   String result = '';
  //   try {
  //     Directory cachePath = await getTemporaryDirectory();
  //     Directory idPath = Directory('${cachePath.path}/$uid/id');
  //     if(idPath.existsSync()) {
  //       idPath.deleteSync(recursive: true);
  //     }
  //     file.copySync('${idPath.path}/${file.path.split('/').last}');
  //     result = 'SUCCESS';
  //   } catch(e) {
  //     result = e.toString();
  //   }
  //   return result;
  // }

  // Future<File> getIdFromCache(String uid, String fileName) async {
  //   try {
  //     Directory cachePath = await getTemporaryDirectory();
  //     Directory idPath = Directory('${cachePath.path}/$uid/id');
  //     return File('${idPath.path}/$fileName');
  //   } catch(e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<String> saveEventAssetToCache(String uid, String eventId, EventAsset eventAsset) async {
    String result = '';
    try {
      Directory cachePath = await getTemporaryDirectory();
      Directory eventPath = Directory('${cachePath.path}/$uid/$eventId');
      if(eventPath.existsSync()) {
        eventPath.deleteSync(recursive: true);
      }
      eventAsset.banner.copySync('${eventPath.path}/${eventAsset.banner.path.split('/').last}');
      eventAsset.showcases.forEach((showcase) => showcase.copySync('${eventPath.path}/showcases/${showcase.path.split('/').last}'));
      eventAsset.permits.forEach((permit) => permit.copySync('${eventPath.path}/permits/${permit.path.split('/').last}'));
      result = 'SUCCESS';
    } catch(e) {
      result = e.toString();
    }
    return result;
  }

  EventAsset getEventAssetFromCache(String uid, String eventId, String banner, List showcases, List permits, Directory cachePath) {
    try {
      EventAsset eventAsset = EventAsset();
      Directory eventPath = Directory('${cachePath.path}/$uid/$eventId');

      eventAsset.banner = File('${eventPath.path}/$banner');
      showcases.forEach((showcase) => eventAsset.showcases.add(File('${eventPath.path}/showcases/$showcase')));
      permits.forEach((permit) => eventAsset.permits.add(File('${eventPath.path}/permits/$permit')));
      return eventAsset;
    } catch(e) {
      print(e);
      return null;
    }
  }
}