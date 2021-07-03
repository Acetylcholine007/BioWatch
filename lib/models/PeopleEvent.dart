class PeopleEvent {
  String eventId;
  String hostId;
  String eventName;
  String hostName;
  String address;
  DateTime datetime;
  String bannerUri;
  List showcaseUris;
  List permitUris;
  String description;
  String createdAt;
  bool isArchive;

  PeopleEvent({
    this.eventId,
    this.hostId,
    this.eventName,
    this.hostName,
    this.address,
    this.datetime,
    this.bannerUri,
    this.showcaseUris,
    this.permitUris,
    this.description,
    this.createdAt,
    this.isArchive
  });

  PeopleEvent copy() {
    return PeopleEvent(
      eventId: this.eventId,
      hostId: this.hostId,
      eventName: this.eventName,
      hostName: this.hostName,
      address: this.address,
      datetime: DateTime.parse(this.datetime.toString()),
      bannerUri: this.bannerUri,
      showcaseUris: [...this.showcaseUris],
      permitUris: [...this.permitUris],
      description: this.description,
      createdAt: this.createdAt,
      isArchive: this.isArchive
    );
  }
}