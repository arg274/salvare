import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salvare/controller/bucket_controller.dart';
import 'package:salvare/controller/resource_controller.dart';
import 'package:salvare/controller/tag_category_controller.dart';
import 'package:salvare/model/bucket.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/model/tag.dart';
import 'package:salvare/theme/constants.dart';

Future<Object?> showResourceForm({
  required BuildContext context,
  bool isEdit = false,
  Resource? resource,
  bool isBucketResource = false,
  Bucket? bucket,
}) async {
  assert(isEdit == false && resource == null ||
      (isEdit == true && resource != null));
  assert(isBucketResource == false && bucket == null ||
      (isBucketResource == true && bucket != null));
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _urlTEC =
      TextEditingController(text: resource?.url);
  final TextEditingController _titleTEC =
      TextEditingController(text: resource?.title);
  final TextEditingController _descTEC =
      TextEditingController(text: resource?.description);
  final TagCategoryController tagCategoryController = TagCategoryController();
  final ResourceController resourceController = ResourceController();
  final BucketController bucketController = BucketController();
  Map<String, Tag> tagMap;
  List<Tag> selectedTags = resource?.tags ?? <Tag>[];
  String selectedCategory = resource?.category ?? 'Default';
  Resource? _resource = resource;
  return await showBlurredDialog(
      context: context,
      dialogBody: AlertDialog(
          shape: dialogShape,
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
                              if (!isEdit && !isBucketResource)
                                {
                                  resourceController.addResource(_resource!),
                                }
                              else if (isEdit && !isBucketResource)
                                {
                                  resourceController.editResource(_resource!),
                                }
                              else if (!isEdit && isBucketResource)
                                {
                                  bucketController.addBucketResource(
                                      bucket!, _resource!),
                                }
                              else if (isEdit && isBucketResource)
                                {
                                  bucketController.editBucketResource(
                                      bucket!, _resource!),
                                }
                            },
                          Navigator.of(context).pop()
                        }
                    },
                child: Text(
                  'ADD',
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
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
                      '${isEdit ? "Edit" : "Add"} Resource',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.fixFontFamily(),
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      style:
                          Theme.of(context).textTheme.formText.fixFontFamily(),
                      controller: _urlTEC,
                      onChanged: (url) => {
                        if (_formkey.currentState!.validate())
                          {
                            // TODO: Fix race condition
                            resourceController
                                .refreshResource(_urlTEC.text, selectedCategory,
                                    selectedTags)
                                .then((resource) => {
                                      _resource = resource,
                                      _titleTEC.text = resource!.title,
                                      _descTEC.text = resource.description,
                                    }),
                          }
                      },
                      decoration: InputDecoration(
                        labelText: 'URL',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .formLabel
                            .fixFontFamily(),
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      validator: (url) {
                        return resourceController.validateURL(url);
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      style:
                          Theme.of(context).textTheme.formText.fixFontFamily(),
                      controller: _titleTEC,
                      decoration: InputDecoration(
                        labelText: 'Title'.toUpperCase(),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .formLabel
                            .fixFontFamily(),
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5.0),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      style:
                          Theme.of(context).textTheme.formText.fixFontFamily(),
                      controller: _descTEC,
                      decoration: InputDecoration(
                        labelText: 'Description'.toUpperCase(),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .formLabel
                            .fixFontFamily(),
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 5.0),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    Visibility(
                      visible: !isBucketResource,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .formLabel
                                .fixFontFamily(),
                          ),
                          FutureBuilder<List<String>?>(
                              future: tagCategoryController.getCategories(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    return DropdownSearch<String>(
                                      popupShape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
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
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            FeatherIcons.search,
                                            color:
                                                Theme.of(context).primaryColor,
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
                                      popupItemBuilder: (context, _text, _) =>
                                          Container(
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
                                      popupBackgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      showSelectedItems: true,
                                      items: snapshot.data,
                                      onChanged: (_selectedCategory) => {
                                        selectedCategory = _selectedCategory!
                                      },
                                      selectedItem: selectedCategory,
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 15.0),
                                        Text(
                                          'No categories found.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  // TODO: Error handling
                                  return Text('${snapshot.error}');
                                } else {
                                  // TODO: Progress indicator
                                  return DropdownSearch<String>(
                                    dropdownSearchDecoration: InputDecoration(
                                      prefixIcon: Icon(
                                        FeatherIcons.folder,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
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
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    popupBackgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    showSelectedItems: true,
                                    selectedItem: 'Loading...',
                                  );
                                }
                              }),
                          const SizedBox(height: 15.0),
                          Text(
                            'Tags'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .formLabel
                                .fixFontFamily(),
                          ),
                          FutureBuilder<List<Tag>?>(
                              future: tagCategoryController.getTags(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    tagMap = {
                                      for (var tag in snapshot.data!)
                                        tag.name: tag
                                    };
                                    return DropdownSearch<
                                        String>.multiSelection(
                                      popupShape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      dropdownSearchDecoration:
                                          const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      multiselectItemTextStyle:
                                          Theme.of(context)
                                              .textTheme
                                              .chipText
                                              .fixFontFamily(),
                                      multiselectItemMargin:
                                          const EdgeInsets.all(2.0),
                                      popupSelectionWidget:
                                          (context, item, isChecked) {
                                        return Checkbox(
                                          value: isChecked,
                                          onChanged: (bool? value) {
                                            isChecked = value!;
                                          },
                                        );
                                      },
                                      popupItemBuilder: (context, _text, _) =>
                                          Container(
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
                                          color:
                                              Theme.of(context).primaryColor),
                                      popupBackgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      showSelectedItems: true,
                                      selectedItems: [
                                        for (var tag in selectedTags) tag.name
                                      ],
                                      items: [
                                        for (var tag in snapshot.data!) tag.name
                                      ],
                                      onChanged: (_selectedTags) => {
                                        selectedTags = [
                                          for (var tag in _selectedTags)
                                            tagMap[tag]!
                                        ]
                                      },
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 15.0),
                                        Text(
                                          'No tags found.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  // TODO: Error handling
                                  return Text('${snapshot.error}');
                                } else {
                                  // TODO: Progress indicator
                                  return SpinKitPianoWave(
                                    color: Theme.of(context).primaryColor,
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                )),
          )));
}
