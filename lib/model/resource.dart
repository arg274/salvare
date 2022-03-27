class Resource {
  String id;
  String title;
  String url;
  String? domain;
  String description;
  DateTime dateCreated;
  DateTime dateUpdated;

  Resource(this.id, this.title, this.url, this.description, this.dateCreated,
      this.dateUpdated);
}
