class PeopleEvent {
  int id;
  String eventName;
  String hostName;
  String address;
  String date;
  String time;
  String bannerUri;
  List<String> photoUri;
  List<String> permitUri;
  List<int> interested;
  List<int> participants;
  String description;

  PeopleEvent({
    this.id,
    this.eventName,
    this.hostName,
    this.address,
    this.date,
    this.time,
    this.bannerUri,
    this.photoUri,
    this.permitUri,
    this.interested,
    this.participants,
    this.description
  });
}