import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
}