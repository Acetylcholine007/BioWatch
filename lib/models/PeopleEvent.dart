class PeopleEvent {
  String eventId;
  String hostId;
  String eventName;
  String hostName;
  String address;
  String date;
  String time;
  String bannerUri;
  List<String> showcaseUris;
  List<String> permitUris;
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
    this.showcaseUris,
    this.permitUris,
    this.description
  });
}