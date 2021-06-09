class PeopleEvent {
  String eventId;
  String hostId;
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
    this.eventId,
    this.hostId,
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