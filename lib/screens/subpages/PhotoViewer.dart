import 'package:flutter/material.dart';

class PhotoViewer extends StatelessWidget {
  PhotoViewer({this.title, this.image});

  final String title;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        color: Colors.black,
        child: InteractiveViewer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image,
            ],
          ),
        ),
      ),
    );
  }
}
