import 'package:bio_watch/models/Enum.dart';

class Activity {
  String id;
  String heading;
  String datetime;
  String body;
  ActivityType type;

  Activity({this.id, this.heading, this.datetime, this.body, this.type});
}