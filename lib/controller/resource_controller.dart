import 'dart:async';

import 'package:flutter/services.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/url_metadata.dart';
import 'package:salvare/utils.dart';

class ResourceController {
  static final ResourceController _singleton = ResourceController._internal();

  factory ResourceController() {
    return _singleton;
  }

  ResourceController._internal();

  Future<Resource?> addResource(String url) async {
    try {
      var metadataFuture = await URLMetadata.fetch(url);
      print(metadataFuture);
      return metadataFuture.exists(Resource.fromMetadata);
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
}
