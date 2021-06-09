import 'Activity.dart';

class AccountData {
  String uid;
  String fullName;
  String accountType;
  String address;
  String contact;
  String birthday;
  List myEvents;
  List<Activity> activities;

  AccountData({
    this.uid,
    this.fullName,
    this.accountType,
    this.address,
    this.contact,
    this.birthday,
    this.myEvents,
    this.activities
  });

  AccountData copy() => AccountData(
    uid: this.uid,
    fullName: this.fullName,
    accountType: this.accountType,
    address: this.address,
    contact: this.contact,
    birthday: this.birthday,
    myEvents: [...this.myEvents],
    activities: [...this.activities]
  );
}