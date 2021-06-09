import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:flutter/foundation.dart';

class EventProvider extends ChangeNotifier {
  List<PeopleEvent> _events;

  EventProvider() {
    _events = [];
  }

  List<PeopleEvent> get events => _events;
}