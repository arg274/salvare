import 'package:metadata_fetch/metadata_fetch.dart';

class URLMetadata {
  static final URLMetadata _singleton = URLMetadata._internal();

  factory URLMetadata() {
    return _singleton;
  }

  URLMetadata._internal();

  static Future<Metadata?> fetch(url) async {
    try {
      return await MetadataFetch.extract(url);
    } catch (e) {
      return null;
    }
  }
}
