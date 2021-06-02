class PeopleEvent {
  int id;
  String eventName;
  String hostName;
  String address;
  String bannerUri;
  List<String> photoUri;
  List<String> permitUri;
  String description;

  PeopleEvent({
    this.id,
    this.eventName,
    this.hostName,
    this.address,
    this.bannerUri,
    this.photoUri,
    this.permitUri,
    this.description
  });
}