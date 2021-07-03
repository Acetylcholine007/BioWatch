import 'package:bio_watch/models/Activity.dart';
import 'package:bio_watch/models/Enum.dart';
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
      idUri: snapshot.get('idUri') ?? '',
      fullName: snapshot.get('fullName') ?? '',
      accountType: snapshot.get('accountType') ?? '',
      address: snapshot.get('address') ?? '',
      contact: snapshot.get('contact') ?? '',
      birthday: snapshot.get('birthday') ?? '',
      sex: snapshot.get('sex') ?? ''
    );
  }

  List<Activity> _activityFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Activity(
        id: doc.id,
        heading: doc.get('heading') ?? '',
        datetime: doc.get('datetime') ?? '',
        body: doc.get('body') ?? '',
        type: ActivityType.values[doc.get('type')] ?? null
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
        datetime: doc.get('datetime').toDate() ?? null,
        bannerUri: doc.get('bannerUri') ?? '',
        showcaseUris: doc.get('showcaseUris') ?? [],
        permitUris: doc.get('permitUris') ?? [],
        description: doc.get('description') ?? '',
        createdAt: doc.get('createdAt') ?? '',
        isArchive: doc.get('isArchive') ?? ''
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
        datetime: doc.get('datetime').toDate() ?? null,
        bannerUri: doc.get('bannerUri') ?? '',
        showcaseUris: doc.get('showcaseUris') ?? [],
        permitUris: doc.get('permitUris') ?? [],
        description: doc.get('description') ?? '',
        createdAt: doc.get('createdAt') ?? '',
        isArchive: doc.get('isArchive') ?? ''
      ));
    }).toList();
  }

  List<AccountData> _accountListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AccountData(
        uid: doc.id,
        idUri: doc.get('idUri') ?? '',
        fullName: doc.get('fullName') ?? '',
        accountType: doc.get('accountType') ?? '',
        address: doc.get('address') ?? '',
        contact: doc.get('contact') ?? '',
        birthday: doc.get('birthday') ?? '',
        sex: doc.get('sex') ?? ''
      );
    }).toList();
  }

  List<Interested> _interestedListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Interested(uid: doc.get('uid') ?? '', datetime: doc.get('datetime') ?? '');
    }).toList();
  }

  List<Participant> _participantListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Participant(uid: doc.get('uid') ?? '', datetime: doc.get('datetime') ?? '');
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

  Future markEvent(String eventId, Activity activity) async {
    return eventCollection
      .doc(eventId).collection('interested').doc(uid).set({
        'uid': uid,
        'datetime': DateTime.now().toString()
      })
      .then((value) {
        addToMyEvents(eventId);
        createActivity(activity);
        print('Event $eventId marked as interested');
      })
      .catchError((error) => print('Failed to mark event $eventId'));
  }

  Future unmarkEvent(String eventId, Activity activity) async {
    return eventCollection
      .doc(eventId).collection('interested').doc(uid).delete()
      .then((value) {
        removeToMyEvents(eventId);
        createActivity(activity);
        print('Event $eventId removed from interests');
      })
      .catchError((error) => print('Failed to remove event $eventId'));
  }

  Future<String> joinEvent(String eventId, Activity activity) async {
    String result = '';
    await eventCollection
      .doc(eventId).collection('participants').doc(uid).set({
        'uid': uid,
        'datetime': DateTime.now().toString()
      })
      .then((value) {
        createActivity(activity);
        print('You\'ve joined the event');
        result = 'SUCCESS';
      })
      .catchError((error) {
      print('Failed to join event $eventId');
      result = error.toString();
    });
    return result;
  }

  Future<String> createEvent(PeopleEvent event) async {
    String eventId = '';
    await eventCollection
      .add({
        'hostId': uid,
        'eventName': event.eventName,
        'hostName': event.hostName,
        'address': event.address,
        'datetime': Timestamp.fromDate(event.datetime),
        'bannerUri': event.bannerUri,
        'showcaseUris': event.showcaseUris,
        'permitUris': event.permitUris,
        'description': event.description,
        'createdAt': event.createdAt,
        'isArchive': event.isArchive
      })
      .then((value) {
        eventId = value.id;
        print('Event ${value.id} created');
      })
      .catchError((error) => print('Failed to create event'));
    return eventId;
  }

  Future<String> editEvent(PeopleEvent event, Activity activity) async {
    await eventCollection.doc(event.eventId).update({
        'eventName': event.eventName,
        'hostName': event.hostName,
        'address': event.address,
        'datetime': Timestamp.fromDate(event.datetime),
        'bannerUri': event.bannerUri,
        'showcaseUris': event.showcaseUris,
        'permitUris': event.permitUris,
        'description': event.description,
        'isArchive': event.isArchive
      })
      .then((value) {
        createActivity(activity);
        print('Event updated');
      })
      .catchError((error) => print('Failed to edit event'));
    return event.eventId;
  }

  Future<String> archiveEvent(String eventId, Activity activity) async {
    String result = '';
    await eventCollection.doc(eventId).update({
      'isArchive': true
    }).then((value) {
      createActivity(activity);
      print('Event archived');
      result = 'SUCCESS';
    }).catchError((error) {
      print('Failed to archive event');
      result = error.toString();
    });
    return result;
  }

  Future<String> cancelEvent(String eventId, Activity activity) async {
    String result = '';
    await eventCollection
      .doc(eventId).delete()
      .then((value) {
        removeToMyEvents(eventId);
        createActivity(activity);
        print('Event $eventId deleted');
        result = 'SUCCESS';
      })
      .catchError((error) {
        print('Failed to remove event $eventId');
        result = error.toString();
      });
    return result;
  }

  Future createActivity(Activity activity) async {
    return activityCollection.doc(uid).collection('activities')
      .add({
        'heading': activity.heading,
        'datetime': activity.datetime,
        'body': activity.body,
        'type': activity.type.index
      })
      .then((value) => print('Activity ${value.id} added'))
      .catchError((error) => print('Failed to record activity'));
  }

  Future removeActivity(String actId) async {
    return activityCollection.doc(uid).collection('activities')
      .doc(actId).delete()
      .then((value) => print('Activity $actId removed'))
      .catchError((error) => print('Failed to remove activity'));
  }

  Future<String> removeActivities() async {
    String result = 'SUCCESS';
    await activityCollection
      .doc(uid).collection('activities').get()
      .then((value) {
        value.docs.forEach((activity) =>
          activityCollection.doc(uid).collection('activities')
            .doc(activity.id).delete()
            .then((result) => print('deleted')));
      })
      .catchError((error) {
        print('Failed to clear activities');
        result = error.toString();
      });
    return result;
  }

  Future createAccount(AccountData person) async {
    return await userCollection.doc(uid).set({
      'idUri': person.idUri,
      'fullName': person.fullName,
      'address': person.address,
      'birthday': person.birthday,
      'accountType': person.accountType,
      'contact': person.contact,
      'sex': person.sex
    })
    .then((value) => print('User data created'))
    .catchError((error) => print('Failed to create user data'));
  }

  Future editAccount(AccountData user, Activity activity) async {
    String result = '';
    await userCollection.doc(uid).update({
      'idUri': user.idUri,
      'contact': user.contact
    })
    .then((value) {
      createActivity(activity);
      result = 'SUCCESS';
    })
    .catchError((error) => result = error.toString());
    return result;
  }

  //GETTER FUNCTIONS

  Future<AccountData> getAccount(String uid) async {
    return userCollection.doc(uid).get().then(_accountFromSnapshot);
  }

  Future<String> getInterestedCount(String eventId) async {
    return eventCollection.doc(eventId).collection('interested').get().then((querySnapshot) => querySnapshot.docs.length.toString());
  }

  Future<List<MyEvent>> myEvents(List<String> eventId) {
    return eventCollection.where('__name__', whereIn: eventId).where('isArchive', isEqualTo: false).get().then((snapshot) {
      List<String> missingIds = eventId.toSet().difference(snapshot.docs.map((doc) => doc.id).toList().toSet()).toList();
      if(missingIds != null && missingIds.isNotEmpty) missingIds.forEach((eventId) => removeToMyEvents(eventId));
      return _myEventListFromSnapshot(snapshot);
    }).catchError((error){
      print(error);
    });
  }

  Future<List<AccountData>> interestedUsers(List<String> userIds) {
    if(userIds.isNotEmpty) {
      return userCollection.where('__name__', whereIn: userIds).get().then(_accountListFromSnapshot);
    } else {
      return Future(() => <AccountData>[]);
    }
  }

  Future<List<AccountData>> participantUsers(List<String> userIds) {
    if(userIds.isNotEmpty) {
      return userCollection.where('__name__', whereIn: userIds).get().then(_accountListFromSnapshot);
    } else {
      return Future(() => <AccountData>[]);
    }
  }

  //STREAM SECTION

  Stream<AccountData> get user {
    return userCollection.doc(uid).snapshots().map(_accountFromSnapshot);
  }

  Stream<List<Activity>> get activity {
    return activityCollection.doc(uid).collection('activities').snapshots().map(_activityFromSnapshot);
  }

  Stream<List<PeopleEvent>> get events {
    return eventCollection.where('isArchive', isEqualTo: false).where('datetime', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now())).snapshots().map(_eventListFromSnapshot);
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