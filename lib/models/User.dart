class User {
  int id;
  String fullName;
  String password;
  String email;
  String accountType;
  String address;
  String contact;
  String birthday;
  List<int> myEvents;

  User({
    this.id,
    this.fullName,
    this.password,
    this.email,
    this.accountType,
    this.address,
    this.contact,
    this.birthday,
    this.myEvents
  });
}