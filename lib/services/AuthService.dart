import 'package:bio_watch/models/Person.dart';
import 'package:bio_watch/models/UserModel.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebaseUser(user));
  }

  Future<User> logIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<UserModel> signIn(Person person) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: person.email, password: person.password);
      User user = result.user;

      await DatabaseService(uid: user.uid).updateUserData(person.fullName, person.address, person.birthday, person.accountType, person.contact, person.myEvents);
      //TODO: add email verification
      // if (user!= null && !user.emailVerified) {
      //   await user.sendEmailVerification();
      // }
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}