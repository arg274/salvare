import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:validators/validators.dart';

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

  factory Resource.fromMetadata(String url, Metadata metadata) {
    DateTime dateCreated = DateTime.now();
    DateTime dateUpdated = dateCreated;
    String? imageURL = isURL(metadata.image) ? metadata.image : null;
    return Resource(
        md5.convert(utf8.encode(url + dateCreated.toString())).toString(),
        metadata.title ?? 'Untitled',
        url,
        metadata.description ?? 'No description.',
        dateCreated,
        dateUpdated,
        imageURL);
  }
}
