import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:metadata_fetch/metadata_fetch.dart';

class Resource {
  String id;
  String title;
  String url;
  String? imageUrl;
  String get domain {
    return Uri.parse(url).host;
  }

  String description;
  DateTime dateCreated;
  DateTime dateUpdated;

  Resource(this.id, this.title, this.url, this.description, this.dateCreated,
      this.dateUpdated, this.imageUrl);

  factory Resource.fromMetadata(Metadata metadata) {
    DateTime dateCreated = DateTime.now();
    DateTime dateUpdated = dateCreated;
    return Resource(
        md5
            .convert(utf8.encode(metadata.url! + dateCreated.toString()))
            .toString(),
        metadata.title ?? 'Untitled',
        metadata.url!,
        metadata.description ?? 'No description.',
        dateCreated,
        dateUpdated,
        metadata.image);
  }
}
