import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  String id;
  String name;
  int color;
  List<String>? resources;
  DateTime dateCreated;
  DateTime dateUpdated;

  Tag(
      {required this.id,
      required this.name,
      required this.color,
      this.resources,
      required this.dateCreated,
      required this.dateUpdated});

  // Named constructor that forwards to the default one.
  Tag.unlaunched(String id, String name, int color)
      : this(
            id: id,
            name: name,
            color: color,
            dateCreated: DateTime.now(),
            dateUpdated: DateTime.now());

  void addResource(String resourceID) =>
      resources != null ? resources!.add(resourceID) : resources = [resourceID];

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
