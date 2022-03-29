class Resource {
  String id;
  String title;
  String url;
  String get domain {
    return Uri.parse(url).host;
  }

  String description;
  DateTime dateCreated;
  DateTime dateUpdated;

  Resource(this.id, this.title, this.url, this.description, this.dateCreated,
      this.dateUpdated);
}
