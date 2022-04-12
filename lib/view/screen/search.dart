import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/resource_controller.dart';
import 'package:salvare/controller/search_controller.dart';
import 'package:salvare/controller/tag_category_controller.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/theme/constants.dart';
import 'package:salvare/view/component/resource_card.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ResourceController resourceController = ResourceController();
  final TagCategoryController tagCategoryController = TagCategoryController();
  final SearchController searchController = SearchController();
  final TextEditingController _queryController = TextEditingController();
  Map<String, Tag>? tagMap;
  String? query;
  String? selectedCategory;
  List<Tag>? selectedTags;
  Future<List<Resource>> searchedResources = Future.value([]);

  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(FeatherIcons.search),
        onPressed: () async {
          setState(() {
            searchedResources = searchController.updateResults(
                query, selectedCategory, selectedTags);
          });
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _queryController,
            onChanged: (_query) => {query = _query},
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5.0),
            ),
          ),
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
                  return const Text('Loading...');
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
                  return const Text('Loading...');
                }
              }),
          Expanded(
            child: FutureBuilder<List<Resource>>(
                future: searchedResources,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => ResourceCard(
                        resource: snapshot.data![index],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // TODO: Error handling
                    return Text('${snapshot.error}');
                  } else {
                    // TODO: Progress indicator
                    return Text('Loading...');
                  }
                }),
          ),
        ],
      ));
}
