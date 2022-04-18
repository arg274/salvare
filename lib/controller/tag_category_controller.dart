import 'package:flutter/material.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/tag.dart';
import 'package:collection/collection.dart';

class TagCategoryController {
  static final TagCategoryController _singleton =
      TagCategoryController._internal();

  factory TagCategoryController() {
    return _singleton;
  }

  TagCategoryController._internal();

  bool tagExists = false;
  bool catExists = false;

  void addTag(Tag tag) async {
    try {
      List<Tag>? currentTags = await FireStoreDB().fetchTagsDB();
      bool _tagExists = false;
      currentTags?.forEach((element) {
        if (element.name == tag.name) {
          _tagExists = true;
        }
      });
      if (_tagExists == true) {
        debugPrint("Tag already exists in the database");
      } else {
        FireStoreDB().addTagDB(tag);
      }
    } catch (err) {
      debugPrint("Error occured in adding tag. tag_category_controller");
    }
  }

  void addCategory(String category) async {
    try {
      List<String>? currentCategories = await FireStoreDB().fetchCategoriesDB();
      if (currentCategories?.contains(category) == true) {
        debugPrint("Category already exists in the database");
      } else {
        FireStoreDB().addCategoryDB(category);
      }
    } catch (err) {
      debugPrint("Error occured in adding category. tag_category_controller");
    }
  }

  Future<List<String>?> getCategories() async {
    try {
      List<String>? currentCategories = await FireStoreDB().fetchCategoriesDB();
      debugPrint("Categories fetched from database");
      return currentCategories;
    } catch (err) {
      debugPrint(
          "Error occured in getting categories. tag_category_controller");
    }
    return null;
  }

  Future<List<Tag>?> getTags() async {
    try {
      List<Tag>? currentTags = await FireStoreDB().fetchTagsDB();
      debugPrint("Tags fetched from database");
      return currentTags;
    } catch (err) {
      debugPrint("Error occured in getting tags. tag_category_controller");
    }
    return null;
  }

  Future<void> checkIfCatExists(String category) async {
    try {
      catExists =
          (await FireStoreDB().fetchCategoriesDB())?.contains(category) ??
              false;
    } catch (err) {
      debugPrint("error in checkIfCatExists {$err}");
      catExists = false;
    }
  }

  Future<void> checkIfTagExists(String tag) async {
    try {
      tagExists = (await FireStoreDB().fetchTagsDB())
                  ?.firstWhereOrNull((_tag) => _tag.name == tag) !=
              null
          ? true
          : false;
    } catch (err) {
      debugPrint("error in checkIfCatExists {$err}");
      catExists = false;
    }
  }

  String? validateCategory(String? category) {
    if (category == null || category.isEmpty) {
      return 'Please enter a name';
    } else {
      return catExists ? 'Category already exists' : null;
    }
  }

  String? validateTag(String? tag) {
    if (tag == null || tag.isEmpty) {
      return 'Please enter a name';
    } else {
      return tagExists ? 'Tag already exists' : null;
    }
  }
}
