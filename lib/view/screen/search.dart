import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/resource_controller.dart';
import 'package:salvare/controller/tag_category_controller.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/utils.dart';
import 'package:salvare/view/component/resource_card.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ResourceController resourceController = ResourceController();
  final TagCategoryController tagCategoryController = TagCategoryController();
  Map<String, Tag>? tagMap;
  List<Tag>? selectedTags;
  String? selectedCategory;
  List<Resource> searchedResources = [];

  void updateResults() async {
    List<Resource> searchedResourcesTag = [];
    List<Resource> searchedResourcesCat = [];
    List<Resource> _searchedResources = [];

    if (selectedCategory != null) {
      searchedResourcesCat =
          await FireStoreDB().searchResourceUsingCategoryDB(selectedCategory!);
    }

    if (selectedTags != null) {
      searchedResourcesTag =
          await FireStoreDB().searchResourceUsingTagListDB(selectedTags!);
    }

    if (selectedTags != null && selectedCategory != null) {
      searchedResourcesTag
          .removeWhere((element) => !searchedResourcesCat.contains(element));
      _searchedResources = searchedResourcesTag;
    } else if (selectedTags != null) {
      _searchedResources = searchedResourcesCat;
    } else if (selectedCategory != null) {
      _searchedResources = searchedResourcesTag;
    }

    setState(() {
      searchedResources = _searchedResources.unique((res) => res.id);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(FeatherIcons.search),
        onPressed: () async {
          updateResults();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
          ),
          FutureBuilder<List<String>?>(
              future: tagCategoryController.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownSearch<String>(
                    mode: Mode.DIALOG,
                    showSearchBox: true,
                    showClearButton: true,
                    popupBackgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    showSelectedItems: true,
                    items: snapshot.data,
                    onChanged: (_selectedCategory) =>
                        {selectedCategory = _selectedCategory!},
                  );
                } else if (snapshot.hasError) {
                  // TODO: Error handling
                  return Text('${snapshot.error}');
                } else {
                  // TODO: Progress indicator
                  return Text('Loading...');
                }
              }),
          const SizedBox(height: 15.0),
          Text(
            'Tags',
            style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
          ),
          FutureBuilder<List<Tag>?>(
              future: tagCategoryController.getTags(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownSearch<String>.multiSelection(
                    mode: Mode.DIALOG,
                    showSearchBox: true,
                    showClearButton: true,
                    popupBackgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    showSelectedItems: true,
                    items: [for (var tag in snapshot.data!) tag.name],
                    onChanged: (_selectedTags) => {
                      tagMap = {for (var tag in snapshot.data!) tag.name: tag},
                      selectedTags = [
                        for (var tag in _selectedTags) tagMap![tag]!
                      ]
                    },
                  );
                } else if (snapshot.hasError) {
                  // TODO: Error handling
                  return Text('${snapshot.error}');
                } else {
                  // TODO: Progress indicator
                  return Text('Loading...');
                }
              }),
          Expanded(
            child: ListView.builder(
                itemCount: searchedResources.length,
                itemBuilder: (context, index) =>
                    ResourceCard(resource: searchedResources[index])),
          ),
        ],
      ));
}
