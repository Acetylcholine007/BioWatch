import 'dart:io';

import 'package:bio_watch/models/EventAsset.dart';
import 'package:bio_watch/services/StorageService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageManager {
  final picker = ImagePicker();
  final StorageService _storage = StorageService();
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
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
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

  Future<String> saveEventAssetToCache(String uid, String eventId, EventAsset eventAsset) async {
    String result = '';
    try {
      Directory cachePath = await getTemporaryDirectory();
      Directory eventPath = Directory('${cachePath.path}/$uid/$eventId');
      if(eventAsset.banner != null) {
        eventAsset.banner.copySync('${eventPath.path}/${eventAsset.banner.path.split('/').last}');
      }
      eventAsset.showcases.forEach((showcase) {
        showcase.copySync('${eventPath.path}/showcases/${showcase.path.split('/').last}');
      });
      eventAsset.permits.forEach((permit) {
        permit.copySync('${eventPath.path}/permits/${permit.path.split('/').last}');
      });
      result = 'SUCCESS';
    } catch(e) {
      result = e.toString();
    }
    return result;
  }

  Future<EventAsset> getEventAssetFromCache(String uid, String eventId, String banner, List showcases, List permits, Directory cachePath) async {
    try {
      EventAsset eventAsset = EventAsset();
      Directory eventPath = Directory('${cachePath.path}/$uid/$eventId');

      imageCache.clear();

      eventAsset.banner = banner != '' ? File('${eventPath.path}/$banner') : null;
      showcases.forEach((showcase) => eventAsset.showcases.add(File('${eventPath.path}/showcases/$showcase')));
      permits.forEach((permit) => eventAsset.permits.add(File('${eventPath.path}/permits/$permit')));

      return eventAsset.hasMissing() ? await _storage.getEventAsset(uid, eventId, banner, showcases, permits, cachePath) : Future(() => eventAsset);
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future clearCache(Directory cachePath, Function refresh) async {
    await new Directory(cachePath.path).delete(recursive: true);
    refresh();
  }
}