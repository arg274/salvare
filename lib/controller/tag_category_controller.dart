import 'package:flutter/material.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/tag.dart';

class TagCategoryController {
  static final TagCategoryController _singleton =
      TagCategoryController._internal();

  factory TagCategoryController() {
    return _singleton;
  }

  TagCategoryController._internal();

  void addTag(Tag tag) async {
    try {
      List<Tag>? currentTags = await FireStoreDB().fetchTagsDB();
      bool doesExist = false;
      currentTags?.forEach((element) {
        if (element.name == tag.name) {
          doesExist = true;
        }
      });
      if (doesExist == true) {
        debugPrint("Tag already exists in the database");
        // TODO: ADD tag already exists TOAST
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
      bool doesExist = false;
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
  }

  Future<List<Tag>?> getTags() async {
    try {
      List<Tag>? currentTags = await FireStoreDB().fetchTagsDB();
      debugPrint("Tags fetched from database");
      return currentTags;
    } catch (err) {
      debugPrint("Error occured in getting tags. tag_category_controller");
    }
  }
}
