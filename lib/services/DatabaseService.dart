import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String fullName, String address, String birthday, String accountType, String contact, List<String> myEvents) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'address': address,
      'birthday': birthday,
      'accountType': accountType,
      'contact': contact,
      'myEvents': myEvents
    });
  }
}