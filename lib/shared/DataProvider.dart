import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Event.dart';
import 'package:bio_watch/models/Person.dart';
import 'package:flutter/foundation.dart';

class DataProvider extends ChangeNotifier {
  String _userId;
  Person _user;
  List<Person> _users;
  List<PeopleEvent> _events;

  DataProvider() {
    _userId = '4';
    _users = [
      Person(
        id: '1',
        fullName: 'Juan Dela Cruz',
        password: '1234',
        email: 'juandelacruz@gmail.com',
        accountType: 'USER',
        address: 'Malolos, Bulacan',
        contact: '09652854493',
        birthday: 'Jan 1, 2000',
        myEvents: ['1', '2'],
        activities: [
          Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 5:00 pm'),
          Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 4:45 pm'),
          Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 4:30 pm')
        ]
      ),
      Person(
        id: '2',
        fullName: 'John Doe',
        password: '1234',
        email: 'johndoe@gmail.com',
        accountType: 'USER',
        address: 'Malolos, Bulacan',
        contact: '09652854493',
        birthday: 'Jan 1, 2000',
        myEvents: ['3'],
          activities: [
            Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 5:00 pm'),
            Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 4:45 pm')
          ]
      ),
      Person(
        id: '3',
        fullName: 'Franklin CLinton',
        password: '1234',
        email: 'franklin@gmail.com',
        accountType: 'USER',
        address: 'Malolos, Bulacan',
        contact: '09652854493',
        birthday: 'Jan 1, 2000',
        myEvents: ['2', '3'],
          activities: [
            Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 4:30 pm')
          ]
      ),
      Person(
        id: '4',
        fullName: 'Trevor Phillips',
        password: '1234',
        email: 'trevor@gmail.com',
        accountType: 'HOST',
        address: 'Malolos, Bulacan',
        contact: '09652854493',
        birthday: 'Jan 1, 2000',
        myEvents: ['1'],
          activities: [
            Activity(heading: 'Activity Type', body: 'Lorem ipsum', date: 'March 3, 2021 5:00 pm')
          ]
      )
    ];
    _events = [
      PeopleEvent(id: '1', eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img1.jpg', address: '305 Malolos, Bulacan', interested: ['1', '2'], participants: []),
      PeopleEvent(id: '2', eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img2.jpg', address: '305 Malolos, Bulacan', interested: ['1', '2' , '3'], participants: ['1', '2']),
      PeopleEvent(id: '3', eventName: 'Event Name', hostName: 'Host Name', description: 'Lorem ipsum dolor sit amet', bannerUri: 'assets/events/img3.jpg', address: '305 Malolos, Bulacan', interested: ['3'], participants: [])
    ];
    _user = _userId == '-1' ? null : _users.where((user) => user.id == _userId).toList()[0];
  }

  String get userId => _userId;

  Person get user => _user;

  List<Person> get users => _users;

  List<PeopleEvent> get events => _events;

  void addInterested(String eventId, String userId) {
    _users.where((user) => user.id == userId).toList()[0].myEvents.add(eventId);
    _events.where((event) => event.id == eventId).toList()[0].interested.add(userId);
    notifyListeners();
  }

  void removeInterested(String eventId, String userId) {
    _users.where((user) => user.id == userId).toList()[0].myEvents.remove(eventId);
    _events.where((event) => event.id == eventId).toList()[0].interested.remove(userId);
    notifyListeners();
  }

  void addEvent(PeopleEvent event) {
    _events.add(event);
    _user.myEvents.add(event.id);
    notifyListeners();
  }

  void editEvent(PeopleEvent newEvent) {
    PeopleEvent event = _events.where((event) => event.id == newEvent.id).toList()[0];
    event = newEvent;
    notifyListeners();
  }

  bool login(String email, String password) {
    print(email + password);
    List<Person> match = _users.where((user) => user.email == email && user.password == password).toList();
    if(match.length == 1) {
      _userId = match[0].id;
      _user = match[0];
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void editAccount(String contact, String password) {
    _user.contact = contact;
    _user.password = password;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _userId = '-1';
    notifyListeners();
  }

  void signIn(Person user) {
    _users.add(user);
    notifyListeners();
  }

  void joinEvent(String eventId, String userId) {
    PeopleEvent event = _events.where((event) => event.id == eventId).toList()[0];
    event.participants.add(userId);
  }
}