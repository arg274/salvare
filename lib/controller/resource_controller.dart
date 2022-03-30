import 'package:flutter/services.dart';
import 'package:salvare/model/resource.dart';

class ResourceController {
  static final ResourceController _singleton = ResourceController._internal();

  factory ResourceController() {
    return _singleton;
  }

  ResourceController._internal();

  static void copyResourceURL(Resource resource) {
    Clipboard.setData(ClipboardData(text: resource.url));
  }
}
