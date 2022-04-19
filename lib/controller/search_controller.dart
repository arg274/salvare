import 'dart:async';

import 'package:flutter/cupertino.dart';
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

  static const int flagCaseSensitive = 1 << 0;
  static const int flagExcludeTitle = 1 << 1;
  static const int flagExcludeDesc = 1 << 2;
  static const int flagExcludeDomain = 1 << 3;
  static const int flagRegex = 1 << 4;

  List<Resource> _filter({
    required List<Resource> resources,
    required String query,
    int flags = 0,
  }) {
    List<Resource> filtered = [];
    bool isCaseSensitive = flags & flagCaseSensitive != 0;
    bool excTitle = flags & flagExcludeTitle != 0;
    bool excDesc = flags & flagExcludeDesc != 0;
    bool excDomain = flags & flagExcludeDomain != 0;
    bool isRegex = flags & flagRegex != 0;

    for (var res in resources) {
      if (isCaseSensitive) {
        if (!excTitle && res.title.contains(!isRegex ? query : RegExp(query))) {
          filtered.add(res);
        } else if (!excDesc &&
            res.description.contains(!isRegex ? query : RegExp(query))) {
          filtered.add(res);
        } else if (!excDomain &&
            res.domain.contains(!isRegex ? query : RegExp(query))) {
          filtered.add(res);
        }
      } else {
        query = query.toLowerCase();
        if (!excTitle &&
            res.title
                .toLowerCase()
                .contains(!isRegex ? query : RegExp(query))) {
          filtered.add(res);
        } else if (!excDesc &&
            res.description
                .toLowerCase()
                .contains(!isRegex ? query : RegExp(query))) {
          filtered.add(res);
        } else if (!excDomain &&
            res.domain
                .toLowerCase()
                .contains(!isRegex ? query : RegExp(query))) {
          filtered.add(res);
        }
      }
    }
    return filtered;
  }

  Future<List<Resource>> updateResults(String? query, String? selectedCategory,
      List<Tag>? selectedTags, int searchFlags) async {
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
      List<Resource> allResources = await FireStoreDB().fetchUserResourceList();
      searchedResourcesTitle = _filter(
        resources: [...allResources],
        query: query,
        flags: searchFlags,
      );
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

  String? validateRegex(String? regexp) {
    if (regexp == null || regexp.isEmpty) {
      return null;
    }
    try {
      RegExp(regexp);
      return null;
    } catch (e) {
      return 'Regex not valid';
    }
  }

  String? validateSearch(String? _query, bool _isRegex) {
    debugPrint('query: $_query, isRegex: $_isRegex');
    if ((_query == null || _query.isEmpty) && !_isRegex) {
      return 'Query is empty';
    } else if (_isRegex) {
      return validateRegex(_query);
    } else if (_query!.length < 3) {
      return 'Query too short';
    } else {
      return null;
    }
  }
}
