import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Interested.dart';
import 'package:bio_watch/models/MyEvent.dart';
import 'package:bio_watch/models/Participant.dart';
import 'package:bio_watch/models/PeopleEvent.dart';
import 'package:bio_watch/models/AccountData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference eventCollection = FirebaseFirestore.instance.collection('events');
  final CollectionReference activityCollection = FirebaseFirestore.instance.collection('activities');

  //MAPPING FUNCTION SECTION

  AccountData _accountFromSnapshot(DocumentSnapshot snapshot) {
    return AccountData(
      uid: snapshot.id,
      fullName: snapshot.get('fullName') ?? '',
      accountType: snapshot.get('accountType') ?? '',
      address: snapshot.get('address') ?? '',
      contact: snapshot.get('contact') ?? '',
      birthday: snapshot.get('birthday') ?? ''
    );
  }

  List<Activity> _activityFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Activity(
        id: doc.id,
        heading: doc.get('heading') ?? '',
        time: doc.get('time') ?? '',
        date: doc.get('date') ?? '',
        body: doc.get('body') ?? ''
      );
    }).toList();
  }

  List<PeopleEvent> _eventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PeopleEvent(
        eventId: doc.id,
        hostId: doc.get('hostId') ?? '',
        eventName: doc.get('eventName') ?? '',
        hostName: doc.get('hostName') ?? '',
        address: doc.get('address') ?? '',
        date: doc.get('date') ?? '',
        time: doc.get('time') ?? '',
        bannerUri: doc.get('bannerUri') ?? '',
        description: doc.get('description') ?? ''
      );
    }).toList();
  }

  List<MyEvent> _myEventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MyEvent(event: PeopleEvent(
        eventId: doc.id,
        hostId: doc.get('hostId') ?? '',
        eventName: doc.get('eventName') ?? '',
        hostName: doc.get('hostName') ?? '',
        address: doc.get('address') ?? '',
        date: doc.get('date') ?? '',
        time: doc.get('time') ?? '',
        bannerUri: doc.get('bannerUri') ?? '',
        description: doc.get('description') ?? '',
      ));
    }).toList();
  }

  List<AccountData> _accountListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AccountData(
        uid: doc.id,
        fullName: doc.get('fullName') ?? '',
        accountType: doc.get('accountType') ?? '',
        address: doc.get('address') ?? '',
        contact: doc.get('contact') ?? '',
        birthday: doc.get('birthday') ?? ''
      );
    }).toList();
  }

  List<Interested> _interestedListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Interested(uid: doc.get('uid') ?? '');
    }).toList();
  }

  List<Participant> _participantListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Participant(uid: doc.get('uid') ?? '');
    }).toList();
  }

  //OPERATOR FUNCTIONS SECTION

  Future addToMyEvents(String eventId) async {
    return userCollection
      .doc(uid).collection('myEvents').doc(eventId).set({
        'eventId': eventId
      })
      .then((value) => print('Added to myEvents'))
      .catchError((error) => print('Failed to add to myEvents'));
  }

  Future removeToMyEvents(String eventId) async {
    return userCollection
      .doc(uid).collection('myEvents').doc(eventId).delete()
      .then((value) => print('Removed from myEvents'))
      .catchError((error) => print('Failed to remove from myEvents'));
  }

  Future markEvent(String eventId) async {
    return eventCollection
      .doc(eventId).collection('interested').doc(uid).set({
        'uid': uid
      })
      .then((value) {
        addToMyEvents(eventId);
        print('Event $eventId marked as interested');
      })
      .catchError((error) => print('Failed to mark event $eventId'));
  }

  Future unmarkEvent(String eventId) async {
    return eventCollection
      .doc(eventId).collection('interested').doc(uid).delete()
      .then((value) {
        removeToMyEvents(eventId);
        print('Event $eventId removed from interests');
      })
      .catchError((error) => print('Failed to remove event $eventId'));
  }

  Future joinEvent(String eventId) async {
    return eventCollection
      .doc(eventId).collection('participants').doc(uid).set({
        'uid': uid
      })
      .then((value) {
        print('You\'ve joined the event');
      })
      .catchError((error) => print('Failed to join event $eventId'));
  }

  Future createEvent(PeopleEvent event, Activity activity) async {
    return eventCollection
      .add({
        'hostId': uid,
        'eventName': event.eventName,
        'hostName': event.hostName,
        'address': event.address,
        'date': event.date,
        'time': event.time,
        'bannerUri': event.bannerUri,
        'description': event.description
      })
      .then((value) {
        addToMyEvents(value.id);
        createActivity(activity);
        //TODO: Mechanism for adding photoUri and permitUri
        print('Event ${value.id} created');
      })
      .catchError((error) => print('Failed to create event'));
  }

  Future editEvent(PeopleEvent event, Activity activity) async {
    return eventCollection.doc(event.eventId)
      .update({
        'eventName': event.eventName,
        'hostName': event.hostName,
        'address': event.address,
        'date': event.date,
        'time': event.time,
        'bannerUri': event.bannerUri,
        'description': event.description
      })
      .then((value) {
        createActivity(activity);
        //TODO: Mechanism for changing photoUri and permitUri
        print('Event updated');
      })
      .catchError((error) => print('Failed to edit event'));
  }

  Future cancelEvent(String eventId, Activity activity) async {
    return eventCollection
      .doc(eventId).delete()
      .then((value) {
        removeToMyEvents(eventId);
        createActivity(activity);
        print('Event $eventId deleted');
      })
      .catchError((error) => print('Failed to remove event $eventId'));
  }

  Future createActivity(Activity activity) async {
    return activityCollection.doc(uid).collection('activities')
      .add({
        'heading': activity.heading,
        'date': activity.date,
        'time': activity.time,
        'body': activity.body,
      })
      .then((value) => print('Activity ${value.id} added'))
      .catchError((error) => print('Failed to record activity'));
  }

  Future viewActivity() async {

  }

  Future removeActivity(String actId) async {
    return activityCollection.doc(uid).collection('activities')
      .doc(actId).delete()
      .then((value) => print('Activity $actId removed'))
      .catchError((error) => print('Failed to remove activity'));
  }

  Future removeActivities() async {
    return activityCollection
      .doc(uid).delete()
      .then((value) => print('User activities cleared'))
      .catchError((error) => print('Failed to clear activities'));
  }

  Future createAccount(String fullName, String address, String birthday, String accountType, String contact) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'address': address,
      'birthday': birthday,
      'accountType': accountType,
      'contact': contact
    })
    .then((value) => print('User data created'))
    .catchError((error) => print('Failed to create user data'));
  }

  Future editAccount(AccountData user) async {
    String result = '';
    await userCollection.doc(uid).update({
      'contact': user.contact
    })
    .then((value) => result = 'SUCCESS')
    .catchError((error) => result = error.toString());
    return result;
  }

  Future<List<MyEvent>> myEvents(List<String> eventId) {
    return eventCollection.where('__name__', whereIn: eventId).get().then(_myEventListFromSnapshot);
  }

  Future<List<AccountData>> interestedUsers(List<String> userIds) {
    return userCollection.where('__name__', whereIn: userIds).get().then(_accountListFromSnapshot);
  }

  Future<List<AccountData>> participantUsers(List<String> userIds) {
    return userCollection.where('__name__', whereIn: userIds).get().then(_accountListFromSnapshot);
  }

  //STREAM SECTION

  Stream<AccountData> get user {
    return userCollection.doc(uid).snapshots().map(_accountFromSnapshot);
  }

  Stream<List<Activity>> get activity {
    return activityCollection.doc(uid).collection('activities').snapshots().map(_activityFromSnapshot);
  }

  Stream<List<PeopleEvent>> get events {
    return eventCollection.snapshots().map(_eventListFromSnapshot);
  }

  Stream<List<String>> get myEventIds {
    return userCollection.doc(uid).collection('myEvents').snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.get('eventId').toString()).toList());
  }

  Stream<List<Interested>> interestedUserIds(String eventId) {
    return eventCollection.doc(eventId).collection('interested').snapshots().map(_interestedListFromSnapshot);
  }

  Stream<List<Participant>> participantUserIds(String eventId) {
    return eventCollection.doc(eventId).collection('participants').snapshots().map(_participantListFromSnapshot);
  }
}