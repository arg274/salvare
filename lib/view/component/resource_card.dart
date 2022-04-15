import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/bucket_controller.dart';
import 'package:salvare/controller/resource_controller.dart';
import 'package:salvare/model/bucket.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/view/component/resource_form.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:salvare/theme/constants.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

final ResourceController resourceController = ResourceController();
final BucketController bucketController = BucketController();

class ResourceCard extends StatelessWidget {
  final Resource resource;
  final bool isBucketResource;
  final Bucket? bucket;

  ResourceCard(
      {Key? key,
      required this.resource,
      this.isBucketResource = false,
      this.bucket})
      : super(key: key) {
    assert(!isBucketResource && bucket == null ||
        isBucketResource && bucket != null);
  }

  ImageProvider<Object> fetchImage(imageURL) {
    var noImg = const AssetImage('assets/no_img.jpg');
    if (imageURL != null) {
      try {
        return CachedNetworkImageProvider(resource.imageUrl!);
      } catch (e) {
        return noImg;
      }
    }
    return noImg;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius)),
        shadowColor: Colors.transparent,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () => resourceController.launchURL(resource.url),
          onLongPress: () => showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        onTap: () {
                          copyLink(context);
                          Navigator.of(context).pop();
                        },
                        leading: Icon(
                          FeatherIcons.copy,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                        title: Text(
                          'Copy Link',
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                    ListTile(
                        onTap: () => showResourceForm(
                              context: context,
                              isEdit: true,
                              resource: resource,
                              isBucketResource: isBucketResource,
                              bucket: bucket,
                            ),
                        leading: Icon(
                          FeatherIcons.edit3,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                        title: Text(
                          'Edit Resource',
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                    ListTile(
                        onTap: () async {
                          showDeleteAlert(context);
                        },
                        leading: const Icon(
                          FeatherIcons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Delete Resource',
                          style: Theme.of(context).textTheme.bodyText1?.apply(
                                color: Colors.red,
                              ),
                        )),
                  ],
                ),
              );
            },
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(cardRadius)),
                  child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: fetchImage(resource.imageUrl),
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/no_img.jpg',
                          fit: BoxFit.cover);
                    },
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(resource.category,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(resource.title,
                              style: Theme.of(context).textTheme.headline6),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(resource.description,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Text(resource.domain,
                              style: Theme.of(context)
                                  .textTheme
                                  .domainText
                                  .apply(
                                      color: Theme.of(context).disabledColor)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      margin: const EdgeInsets.all(1.0),
                      child: IconButton(
                        onPressed: () {
                          copyLink(context);
                        },
                        icon: const Icon(FeatherIcons.copy),
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void copyLink(BuildContext context) {
    resourceController.copyResourceURL(resource);
    showToast(
      'Link copied to the clipboard!',
      context: context,
      animation: StyledToastAnimation.slideFromBottom,
      curve: Curves.decelerate,
      reverseAnimation: StyledToastAnimation.fade,
    );
  }

  Future<Object?> showDeleteAlert(BuildContext context) async {
    return await showBlurredDialog(
        context: context,
        dialogBody: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: dialogShape,
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  !isBucketResource
                      ? resourceController.deleteResource(resource)
                      : bucketController.deleteBucketResource(
                          bucket!, resource);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Yes'.toUpperCase(),
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                )),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'No'.toUpperCase(),
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                )),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete'.toUpperCase(),
                style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Are you sure that you want to delete this resource?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ));
  }
}
