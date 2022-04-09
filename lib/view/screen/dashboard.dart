import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:salvare/controller/dashboard_controller.dart';
import 'package:salvare/controller/resource_controller.dart';
import 'package:salvare/controller/tag_category_controller.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/theme/constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ResourceController resourceController = ResourceController();
  final TagCategoryController tagCategoryController = TagCategoryController();
  List<Resource> resources = <Resource>[];

  _addResource(Resource resource) {
    setState(() {
      resources.add(resource);
    });
  }

  Future<void> showAddCategoryDialogue(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _catTEC = TextEditingController();
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: <Widget>[
              TextButton(
                  onPressed: () => {
                        if (_formkey.currentState!.validate())
                          {
                            tagCategoryController.addCategory(_catTEC.text),
                            Navigator.of(context).pop()
                          }
                      },
                  child: Text(
                    'ADD',
                    style:
                        Theme.of(context).textTheme.buttonText.fixFontFamily(),
                  ))
            ],
            content: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Category',
                    style:
                        Theme.of(context).textTheme.formLabel.fixFontFamily(),
                  ),
                  TextFormField(
                    controller: _catTEC,
                    onChanged: (category) => {},
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    validator: (category) {
                      return resourceController.validateCategory(category);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> showAddTagDialogue(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    final TextEditingController _tagTEC = TextEditingController();
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: <Widget>[
              TextButton(
                  onPressed: () => {
                        if (_formkey.currentState!.validate())
                          {
                            tagCategoryController.addTag(
                                Tag.unlaunched(_tagTEC.text, 0xFFFFC107)),
                            Navigator.of(context).pop()
                          }
                      },
                  child: Text(
                    'ADD',
                    style:
                        Theme.of(context).textTheme.buttonText.fixFontFamily(),
                  ))
            ],
            content: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tag',
                    style:
                        Theme.of(context).textTheme.formLabel.fixFontFamily(),
                  ),
                  TextFormField(
                    controller: _tagTEC,
                    onChanged: (tag) => {},
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    validator: (tag) {
                      return resourceController.validateTag(tag);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> showAddLinkDialogue(BuildContext context) async {
    final _formkey = GlobalKey<FormState>();
    Map<String, Tag> tagMap;
    List<Tag> selectedTags = <Tag>[];
    String selectedCategory = 'Default';
    int timePassedMs = 1000;
    Timer inputChangeFreqTimer =
        Timer.periodic(const Duration(milliseconds: 100), (_) {
      timePassedMs += 100;
    });
    Resource? _resource;
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _urlTEC = TextEditingController();
          final TextEditingController _titleTEC = TextEditingController();
          final TextEditingController _descTEC = TextEditingController();
          return AlertDialog(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              actions: <Widget>[
                TextButton(
                    onPressed: () => {
                          if (_formkey.currentState!.validate())
                            {
                              if (_resource != null)
                                {
                                  _resource!.title = _titleTEC.text,
                                  _resource!.description = _descTEC.text,
                                  _resource!.category = selectedCategory,
                                  _resource!.tags = selectedTags,
                                  _addResource(_resource!),
                                  resourceController.addResource(_resource!),
                                },
                              Navigator.of(context).pop()
                            }
                        },
                    child: Text(
                      'ADD',
                      style: Theme.of(context)
                          .textTheme
                          .buttonText
                          .fixFontFamily(),
                    ))
              ],
              content: SingleChildScrollView(
                child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'URL',
                          style: Theme.of(context)
                              .textTheme
                              .formLabel
                              .fixFontFamily(),
                        ),
                        TextFormField(
                          controller: _urlTEC,
                          onChanged: (url) => {
                            if (_formkey.currentState!.validate())
                              {
                                // TODO: Fix race condition
                                resourceController
                                    .refreshResource(_urlTEC.text,
                                        selectedCategory, selectedTags)
                                    .then((resource) => {
                                          _resource = resource,
                                          _titleTEC.text = resource!.title,
                                          _descTEC.text = resource.description,
                                        }),
                              }
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          validator: (url) {
                            return resourceController.validateURL(url);
                          },
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          'Title',
                          style: Theme.of(context)
                              .textTheme
                              .formLabel
                              .fixFontFamily(),
                        ),
                        TextFormField(
                          controller: _titleTEC,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          'Description',
                          style: Theme.of(context)
                              .textTheme
                              .formLabel
                              .fixFontFamily(),
                        ),
                        TextFormField(
                          controller: _descTEC,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          'Category',
                          style: Theme.of(context)
                              .textTheme
                              .formLabel
                              .fixFontFamily(),
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
                                  selectedItem: 'Default',
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
                          style: Theme.of(context)
                              .textTheme
                              .formLabel
                              .fixFontFamily(),
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
                                  items: [
                                    for (var tag in snapshot.data!) tag.name
                                  ],
                                  onChanged: (_selectedTags) => {
                                    tagMap = {
                                      for (var tag in snapshot.data!)
                                        tag.name: tag
                                    },
                                    selectedTags = [
                                      for (var tag in _selectedTags)
                                        tagMap[tag]!
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
                      ],
                    )),
              ));
        });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: SpeedDial(
          icon: FeatherIcons.plus,
          activeIcon: FeatherIcons.x,
          children: [
            SpeedDialChild(
              child: const Icon(FeatherIcons.link),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: 'Resource',
              onTap: () => showAddLinkDialogue(context),
            ),
            SpeedDialChild(
              child: const Icon(FeatherIcons.folder),
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              label: 'Category',
              onTap: () => showAddCategoryDialogue(context),
            ),
            SpeedDialChild(
              child: const Icon(FeatherIcons.tag),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              label: 'Tag',
              onTap: () => showAddTagDialogue(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
              padding: globalEdgeInsets,
              child: DashboardController().getResourceStreamBuilder()),
        ),
      );
}
