import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/models/User.dart';
import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  User _user;
  List<int> _myEvents;
  List<PeopleEvent> _events;
  List<Activity> _activities;

  DataProvider() {
    _user = User(
      fullName: 'Juan Dela Cruz',
      password: '1234',
      email: 'juandelacruz@gmail.com',
      accountType: 'USER',
      address: 'Malolos, Bulacan',
      contact: '09652854493',
      birthday: 'Jan 1, 2000'
    );
    _myEvents = [1, 2];
    _events = [
      PeopleEvent(id: 1, eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img1.jpg', address: '305 Malolos, Bulacan'),
      PeopleEvent(id: 2, eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img2.jpg', address: '305 Malolos, Bulacan'),
      PeopleEvent(id: 3, eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img3.jpg', address: '305 Malolos, Bulacan')
    ];
    _activities = [
      Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 5:00 pm'),
      Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 4:45 pm'),
      Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 4:30 pm')
    ];
  }

  User get user => _user;

  List<int> get myEvents => _myEvents;

  List<PeopleEvent> get events => _events;

  List<Activity> get activities => _activities;


}