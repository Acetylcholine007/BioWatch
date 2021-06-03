import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/models/User.dart';
import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  int _user;
  List<User> _users;
  List<PeopleEvent> _events;
  List<Activity> _activities;

  DataProvider() {
    _user = 1;
    _users = [
      User(
        id: 1,
        fullName: 'Juan Dela Cruz',
        password: '1234',
        email: 'juandelacruz@gmail.com',
        accountType: 'USER',
        address: 'Malolos, Bulacan',
        contact: '09652854493',
        birthday: 'Jan 1, 2000',
        myEvents: [1, 2]
      ),
      User(
        id: 2,
        fullName: 'John Doe',
        password: '1234',
        email: 'johndoe@gmail.com',
        accountType: 'USER',
        address: 'Malolos, Bulacan',
        contact: '09652854493',
        birthday: 'Jan 1, 2000',
        myEvents: [3]
      ),
      User(
        id: 3,
        fullName: 'Franklin CLinton',
        password: '1234',
        email: 'franklin@gmail.com',
        accountType: 'USER',
        address: 'Malolos, Bulacan',
        contact: '09652854493',
        birthday: 'Jan 1, 2000',
        myEvents: [2, 3]
      ),
      User(
        id: 4,
        fullName: 'Trevor Phillips',
        password: '1234',
        email: 'trevor@gmail.com',
        accountType: 'HOST',
        address: 'Malolos, Bulacan',
        contact: '09652854493',
        birthday: 'Jan 1, 2000',
        myEvents: [1]
      )
    ];
    _events = [
      PeopleEvent(id: 1, eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img1.jpg', address: '305 Malolos, Bulacan', interested: [1, 2], participants: [1]),
      PeopleEvent(id: 2, eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img2.jpg', address: '305 Malolos, Bulacan', interested: [1, 2 , 3], participants: [1, 2]),
      PeopleEvent(id: 3, eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img3.jpg', address: '305 Malolos, Bulacan', interested: [3], participants: [])
    ];
    _activities = [
      Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 5:00 pm'),
      Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 4:45 pm'),
      Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 4:30 pm')
    ];
  }

  int get user => _user;

  List<User> get users => _users;

  List<PeopleEvent> get events => _events;

  List<Activity> get activities => _activities;

  void addInterested(int eventId, int userId) {
    _users.where((user) => user.id == userId).toList()[0].myEvents.add(eventId);
    _events.where((event) => event.id == eventId).toList()[0].interested.add(userId);
    notifyListeners();
  }

  void removeInterested(int eventId, int userId) {
    _users.where((user) => user.id == userId).toList()[0].myEvents.remove(eventId);
    _events.where((event) => event.id == eventId).toList()[0].interested.remove(userId);
    notifyListeners();
  }
}