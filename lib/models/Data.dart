import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Participant.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class Data {
  String uid;
  PeopleEvent event;
  List<Participant> participants;
  Map<String, String> datetimes;

  Data({this.uid, this.event, this.participants, this.datetimes});

  int getAge(String birthdayString) {
    int age = 0;
    DateTime birthday = DateTime.parse(birthdayString);
    DateTime today = DateTime.now();
    age = today.year - birthday.year;

    return today.month >= birthday.month && today.day >= birthday.day ? age : age - 1;
  }

  Future<String> exportData(String eventId) async {
    ZipFileEncoder encoder = ZipFileEncoder();
    DatabaseService _database = DatabaseService(uid: uid);
    List<AccountData> users = await _database.participantUsers(participants.map((participant) => participant.uid).toList());

    Directory cachePath = await getTemporaryDirectory();
    Directory newPath = await Directory('${cachePath.path}/$uid/$eventId/export').create(recursive: true);
    File jsonFile = await File('${cachePath.path}/$uid/$eventId/export/data.json').create(recursive: true);
    File csvFile = await File('${cachePath.path}/$uid/$eventId/export/data.csv').create(recursive: true);

    Map<String, dynamic> jsonData = {};
    List<List> csvData = [];

    jsonData['event'] = {
      'eventId': event.eventId,
      'hostId': event.hostId,
      'eventName': event.eventName,
      'hostName': event.hostName,
      'createdAt': event.createdAt,
      'address': event.address,
      'date': event.date,
      'time': event.time,
      'description': event.description
    };

    jsonData['participants'] = [];

    users.forEach((user) => jsonData['participants'].add(
      {
        'uid': user.uid,
        'fullName': user.fullName,
        'address': user.address,
        'contact': user.contact,
        'age': getAge(user.birthday).toString(),
        'joined': datetimes[user.uid],
      }
    ));

    jsonData['participants'].forEach((participant) => csvData.add(participant.values.toList()));

    try {
      //Create json file
      String json = JsonEncoder().convert(jsonData);
      await jsonFile.writeAsString(json);

      //Create csv file
      String csv = ListToCsvConverter().convert(<List<dynamic>>[['uid', 'fullName', 'address', 'contact', 'age', 'joined']] + csvData);
      await csvFile.writeAsString(csv);

      //archive and share
      encoder.zipDirectory(newPath, filename: '${cachePath.path}/$uid/$eventId/data.zip');

      Share.shareFiles(['${cachePath.path}/$uid/$eventId/data.zip'], text: event.eventName, subject: 'Bio Watch Event Data');

      return 'SUCCESS';
    } catch(e) {
      return e.toString();
    }
  }
}