class AccountData {
  String uid;
  String idUri;
  String fullName;
  String accountType;
  String address;
  String contact;
  String birthday;
  String sex;
  String email;

  AccountData({
    this.uid,
    this.idUri,
    this.fullName,
    this.accountType,
    this.address,
    this.contact,
    this.birthday,
    this.sex,
    this.email
  });

  AccountData copy() => AccountData(
    uid: this.uid,
    idUri: this.idUri,
    fullName: this.fullName,
    accountType: this.accountType,
    address: this.address,
    contact: this.contact,
    birthday: this.birthday,
    sex: this.sex,
    email: this.email
  );
}