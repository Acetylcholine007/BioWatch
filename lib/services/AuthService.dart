import 'dart:io';

import 'package:bio_watch/models/AccountData.dart';
import 'package:bio_watch/models/Account.dart';
import 'package:bio_watch/services/DatabaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'StorageService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //MAPPING FUNCTION SECTION

  Account _userFromFirebaseUser(User user) {
    return user != null ? Account(uid: user.uid, email: user.email) : null;
  }

  //STREAM SECTION

  Stream<Account> get user {
    return _auth.authStateChanges().map((User user) => _userFromFirebaseUser(user));
  }

  //OPERATOR FUNCTIONS SECTION

  Future<String> logIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'SUCCESS';
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> signIn(AccountData accountData, String email, String password, File file) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      //TODO: add email verification
      // if (user!= null && !user.emailVerified) {
      //   await user.sendEmailVerification();
      // }
      await DatabaseService(uid: user.uid).createAccount(accountData);
      await StorageService().uploadId(user.uid, file, await getTemporaryDirectory());
      return 'SUCCESS';
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> logOut() async {
    String result  = '';
    await _auth.signOut()
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> changeEmail(String newEmail) async {
    String result  = '';
    await _auth.currentUser.updateEmail(newEmail)
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> changePassword(String newPassword) async {
    String result  = '';
    await _auth.currentUser.updatePassword(newPassword)
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }
}