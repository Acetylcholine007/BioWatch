import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDisplay extends StatelessWidget {
  final String eventId;

  QRDisplay({this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Container(
        child: Center(
          child: QrImage(
            data:eventId,
            version: QrVersions.auto,
            size: 300.0,
          ),
        ),
      ),
    );
  }
}
