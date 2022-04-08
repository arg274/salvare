import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/model/url_metadata.dart';
import 'package:validators/validators.dart';

class ResourceController {
  static final ResourceController _singleton = ResourceController._internal();

  factory ResourceController() {
    return _singleton;
  }

  ResourceController._internal();

  void addResource(String url) async {
    try {
      if (!url.startsWith('http')) {
        url = 'http://' + url;
      }
      var metadataFuture = await URLMetadata.fetch(url);
      debugPrint("MetadataFuture: $metadataFuture");
      if (metadataFuture != null) {
        Resource resource = Resource.fromMetadata(url, metadataFuture);
        resource.addTag(Tag.unlaunched(
            'testTag2', 'morbo2', Colors.amber[100]?.value ?? 1));
        resource.addTag(Tag.unlaunched(
            'anotherTestTag2', 'moiragelam2', Colors.red[100]?.value ?? 2));
        FireStoreDB().addResourceDB(resource);
      }
    } on TimeoutException {
      // TODO: SHOW TOAST
    } on Error catch (e) {
      debugPrint("Error: $e");
      // TODO: SHOW TOAST
    }
  }

  void copyResourceURL(Resource resource) {
    Clipboard.setData(ClipboardData(text: resource.url));
  }

  String? validateURL(String? url) {
    if (url == null || url.isEmpty) {
      return 'Please enter a URL';
    } else if (!isURL(url)) {
      return 'Please enter a valid URL.';
    } else {
      return null;
    }
  }
}
