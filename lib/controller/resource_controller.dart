import 'dart:async';

import 'package:flutter/services.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/model/url_metadata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

class ResourceController {
  static final ResourceController _singleton = ResourceController._internal();
  final firestoreDB = FireStoreDB();

  factory ResourceController() {
    return _singleton;
  }

  ResourceController._internal();

  Future<Resource?> refreshResource(
      String url, String category, List<Tag>? tags) async {
    if (!url.startsWith('http')) {
      url = 'http://' + url;
    }
    var metadataFuture = await URLMetadata.fetch(url);
    print(metadataFuture);
    if (metadataFuture != null) {
      Resource resource = Resource.fromMetadata(url, metadataFuture);
      return resource;
    }
    Resource unreachableResource =
        Resource.fromUnreachableURL(url, category, tags);
    return unreachableResource;
  }

  Future<void> addResource(Resource resource) async {
    firestoreDB.addResourceDB(resource);
  }

  Future<void> editResource(Resource resource) async {
    firestoreDB.editResourceDB(resource);
  }

  Future<void> deleteResource(Resource resource) async {
    firestoreDB.deleteResourceDB(resource);
  }

  void copyResourceURL(Resource resource) {
    Clipboard.setData(ClipboardData(text: resource.url));
  }

  String? validateURL(String? url) {
    if (url == null || url.isEmpty) {
      return 'Please enter a URL';
    } else if (!isURL(url)) {
      return 'Please enter a valid URL';
    } else {
      return null;
    }
  }

  String? validateCategory(String? category) {
    if (category == null || category.isEmpty) {
      return 'Please enter a category';
    } else {
      return null;
    }
  }

  String? validateTag(String? tags) {
    if (tags == null || tags.isEmpty) {
      return 'Please enter a tag';
    } else {
      return null;
    }
  }

  void launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
