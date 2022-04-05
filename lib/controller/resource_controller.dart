import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/url_metadata.dart';
import 'package:salvare/utils.dart';
import 'package:validators/validators.dart';

class ResourceController {
  static final ResourceController _singleton = ResourceController._internal();

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
      if (metadataFuture != null) {
        Resource resource = Resource.fromMetadata(url, metadataFuture);
        FireStoreDB().addResource(resource);
        List<Resource>? lst =
            await FireStoreDB().searchResourceUsingURL('pasa');
        print("resourceController got back search result: ${lst?.length}");
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
