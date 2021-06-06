import 'Activity.dart';

class User {
  String id;
  String fullName;
  String password;
  String email;
  String accountType;
  String address;
  String contact;
  String birthday;
  List<String> myEvents;
  List<Activity> activities;

  User({
    this.id,
    this.fullName,
    this.password,
    this.email,
    this.accountType,
    this.address,
    this.contact,
    this.birthday,
    this.myEvents,
    this.activities
  });

  User copy() => User(
    id: this.id,
    fullName: this.fullName,
    password: this.password,
    email: this.email,
    accountType: this.accountType,
    address: this.address,
    contact: this.contact,
    birthday: this.birthday,
    myEvents: [...this.myEvents],
    activities: [...this.activities]
  );
}