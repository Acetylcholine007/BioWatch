class PeopleEvent {
  String id;
  String eventName;
  String hostName;
  String address;
  String date;
  String time;
  String bannerUri;
  List<String> photoUri;
  List<String> permitUri;
  List<String> interested;
  List<String> participants;
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