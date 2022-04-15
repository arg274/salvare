import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:salvare/model/tag.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:validators/validators.dart';

import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable()
class Resource {
  String id;
  String title;
  String url;
  String? imageUrl;
  String get domain {
    return Uri.parse(url).host.toLowerCase();
  }

  String description;
  String category;
  List<Tag>? tags;
  DateTime dateCreated;
  DateTime dateUpdated;

  Resource(this.id, this.title, this.url, this.category, this.tags,
      this.description, this.dateCreated, this.dateUpdated, this.imageUrl);

  Resource.unlaunched(String id, String title, String url, String category)
      : this(id, title, url, category, null, 'No description.', DateTime.now(),
            DateTime.now(), null);

  void addTag(Tag _tag) {
    tags != null ? tags!.add(_tag) : tags = List<Tag>.from([_tag]);
  }

  void changeCategory(String _to) {
    category = _to;
  }

  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceToJson(this);

  @override
  String toString() => toJson().toString();

  factory Resource.fromUnreachableURL(
      String url, String category, List<Tag>? tags) {
    DateTime dateCreated = DateTime.now();
    DateTime dateUpdated = dateCreated;
    return Resource(
        md5.convert(utf8.encode(url + dateCreated.toString())).toString(),
        'Untitled',
        url,
        category,
        tags,
        'No Description',
        dateCreated,
        dateUpdated,
        null);
  }

  factory Resource.fromMetadata(String url, Metadata metadata) {
    DateTime dateCreated = DateTime.now();
    DateTime dateUpdated = dateCreated;
    String? imageURL = isURL(metadata.image) ? metadata.image : null;
    return Resource(
        md5.convert(utf8.encode(url + dateCreated.toString())).toString(),
        metadata.title ?? 'Untitled',
        url,
        'default',
        null,
        metadata.description ?? 'No description.',
        dateCreated,
        dateUpdated,
        imageURL);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Resource && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
