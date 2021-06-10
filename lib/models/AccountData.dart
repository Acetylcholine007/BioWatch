class AccountData {
  String uid;
  String fullName;
  String accountType;
  String address;
  String contact;
  String birthday;

  AccountData({
    this.uid,
    this.fullName,
    this.accountType,
    this.address,
    this.contact,
    this.birthday,
  });

  AccountData copy() => AccountData(
    uid: this.uid,
    fullName: this.fullName,
    accountType: this.accountType,
    address: this.address,
    contact: this.contact,
    birthday: this.birthday,
  );
}