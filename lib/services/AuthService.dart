import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Account _userFromFirebaseUser(User user) {
    return user != null ? Account(uid: user.uid) : null;
  }

  Stream<Account> get user {
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

  Future<Account> signIn(AccountData person, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      await DatabaseService(uid: user.uid).createAccount(person.fullName, person.address, person.birthday, person.accountType, person.contact);
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