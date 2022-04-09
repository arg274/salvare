import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:salvare/model/resource.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  String id;
  String name;
  int color;
  List<Resource>? resources;
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
  factory Tag.unlaunched(String name, int color) {
    DateTime dateCreated = DateTime.now();
    DateTime dateUpdated = dateCreated;
    return Tag(
        id: md5.convert(utf8.encode(name + dateCreated.toString())).toString(),
        name: name,
        color: color,
        dateCreated: dateCreated,
        dateUpdated: dateUpdated);
  }

  void addResource(Resource resource) =>
      resources != null ? resources!.add(resource) : resources = [resource];

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  Map<String, dynamic> toJson() => _$TagToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
