import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:salvare/database/firebase_utility.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/url_metadata.dart';
import 'package:salvare/utils.dart';
import 'package:validators/validators.dart';

class ResourceController {
  static final ResourceController _singleton = ResourceController._internal();
  final User? user = FirebaseAuth.instance.currentUser;

  factory ResourceController() {
    return _singleton;
  }

  ResourceController._internal();

  Future<Resource?> addResource(String url) async {
    try {
      if (!url.startsWith('http')) {
        url = 'http://' + url;
      }
      var metadataFuture = await URLMetadata.fetch(url);
      print(metadataFuture);
      // TODO: Resource should still be allowed if metadata is non-existent
      if (metadataFuture != null) {
        Resource resource = Resource.fromMetadata(url, metadataFuture);
        FirebaseUtility(user: user!).addResourceDB(resource);
        return resource;
      }
      return null;
    } on TimeoutException {
      // TODO: SHOW TOAST
    } on Error catch (e) {
      print(e);
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
