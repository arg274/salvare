import 'package:flutter/material.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/tag.dart';

class TagCategoryController {
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
      List<String>? currentTags = await FireStoreDB().fetchCategoriesDB();
      bool doesExist = false;
      currentTags?.forEach((element) {
        if (element == category) {
          doesExist = true;
        }
      });
      if (doesExist == true) {
        debugPrint("Category already exists in the database");
        // TODO: ADD category already exists TOAST
      } else {
        FireStoreDB().addCategoryDB(category);
      }
    } catch (err) {
      debugPrint("Error occured in adding category. tag_category_controller");
    }
  }
}
