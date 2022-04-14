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
  bool filtersExpanded = false;
  final PageStorageKey<String> expansionTileKey =
      const PageStorageKey('expansionTile');
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
          const SizedBox(height: 80),
          TextFormField(
            style: Theme.of(context).textTheme.bodyText1?.fixFontFamily(),
            textAlignVertical: TextAlignVertical.center,
            controller: _queryController,
            onChanged: (_query) => {query = _query},
            decoration: InputDecoration(
              prefixIcon: Icon(
                FeatherIcons.search,
                color: Theme.of(context).primaryColor,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
            ),
          ),
          ExpansionTile(
            // TODO: Preserve children state
            key: expansionTileKey,
            tilePadding: EdgeInsets.zero,
            trailing: Icon(
              filtersExpanded
                  ? FeatherIcons.chevronUp
                  : FeatherIcons.chevronDown,
              color: Theme.of(context).primaryColor,
            ),
            onExpansionChanged: (bool expanded) {
              setState(() => filtersExpanded = expanded);
            },
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            title: Text(
              'Filters'.toUpperCase(),
              style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
            ),
            children: [
              Text(
                'Category'.toUpperCase(),
                style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
              ),
              FutureBuilder<List<String>?>(
                  future: tagCategoryController.getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownSearch<String>(
                        popupShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        dropdownSearchDecoration: InputDecoration(
                          prefixIcon: Icon(
                            FeatherIcons.folder,
                            color: Theme.of(context).primaryColor,
                          ),
                          isDense: true,
                        ),
                        searchFieldProps: TextFieldProps(
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.fixFontFamily(),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              FeatherIcons.search,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        dropDownButton: Icon(
                          FeatherIcons.chevronDown,
                          color: Theme.of(context).primaryColor,
                        ),
                        dropdownBuilder: (_, _text) => Container(
                          child: _text != null
                              ? Text(
                                  _text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.fixFontFamily(),
                                )
                              : null,
                        ),
                        popupItemBuilder: (context, _text, _) => Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            _text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.fixFontFamily(),
                          ),
                        ),
                        mode: Mode.DIALOG,
                        showSearchBox: true,
                        showClearButton: true,
                        clearButton: Icon(FeatherIcons.xCircle,
                            color: Theme.of(context).primaryColor),
                        popupBackgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        showSelectedItems: true,
                        items: snapshot.data,
                        onChanged: (_selectedCategory) =>
                            {selectedCategory = _selectedCategory},
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
                'Tags'.toUpperCase(),
                style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
              ),
              FutureBuilder<List<Tag>?>(
                  future: tagCategoryController.getTags(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownSearch<String>.multiSelection(
                        popupShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        dropdownSearchDecoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        multiselectItemTextStyle: Theme.of(context)
                            .textTheme
                            .chipText
                            .fixFontFamily(),
                        multiselectItemMargin: const EdgeInsets.all(2.0),
                        popupSelectionWidget: (context, item, isChecked) {
                          return Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.selected)) {
                                return Theme.of(context).primaryColor;
                              }
                              return Theme.of(context).scaffoldBackgroundColor;
                            }),
                            value: isChecked,
                            shape: const CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          );
                        },
                        popupItemBuilder: (context, _text, _) => Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            _text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.fixFontFamily(),
                          ),
                        ),
                        dropDownButton: Icon(
                          FeatherIcons.chevronDown,
                          color: Theme.of(context).primaryColor,
                        ),
                        mode: Mode.DIALOG,
                        showSearchBox: true,
                        showClearButton: true,
                        clearButton: Icon(FeatherIcons.xCircle,
                            color: Theme.of(context).primaryColor),
                        popupBackgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        showSelectedItems: true,
                        items: [for (var tag in snapshot.data!) tag.name],
                        onChanged: (_selectedTags) => {
                          tagMap = {
                            for (var tag in snapshot.data!) tag.name: tag
                          },
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
            ],
          ),
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
