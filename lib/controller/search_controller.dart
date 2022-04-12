import 'dart:async';

import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/utils.dart';

class SearchController {
  static final SearchController _singleton = SearchController._internal();

  factory SearchController() {
    return _singleton;
  }

  SearchController._internal();

  Future<List<Resource>> updateResults(
      String? query, String? selectedCategory, List<Tag>? selectedTags) async {
    bool isTitleEnabled = (query != null && query.isNotEmpty);
    bool isCatEnabled =
        (selectedCategory != null && selectedCategory.isNotEmpty);
    bool isTagEnabled = (selectedTags != null);
    List<Resource> searchedResourcesTitle = [];
    List<Resource> searchedResourcesTag = [];
    List<Resource> searchedResourcesCat = [];
    List<Resource> _searchedResources = [];

    List<List<Resource>> listsToIntersect = [];

    if (isTitleEnabled) {
      searchedResourcesTitle =
          await FireStoreDB().searchResourceUsingTitleDB(query);
      listsToIntersect.add(searchedResourcesTitle);
    }

    if (isCatEnabled) {
      searchedResourcesCat =
          await FireStoreDB().searchResourceUsingCategoryDB(selectedCategory);
      listsToIntersect.add(searchedResourcesCat);
    }

    if (isTagEnabled) {
      searchedResourcesTag =
          await FireStoreDB().searchResourceUsingTagListDB(selectedTags);
      listsToIntersect.add(searchedResourcesTag);
    }

    if (listsToIntersect.isNotEmpty) {
      _searchedResources = listsToIntersect.first;
      for (List<Resource> list in listsToIntersect) {
        _searchedResources.removeWhere((res) => !list.contains(res));
      }
    }

    return _searchedResources.unique((res) => res.id);
  }
}
