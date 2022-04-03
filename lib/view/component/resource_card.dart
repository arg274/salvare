import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:salvare/controller/resource_controller.dart';
import 'package:salvare/model/resource.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:salvare/theme/constants.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

final ResourceController resourceController = ResourceController();

class ResourceCard extends StatelessWidget {
  final Resource resource;

  const ResourceCard({required this.resource, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).shadowColor,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: resource.imageUrl ?? 'https://picsum.photos/250?image=9',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
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
                              .domaintext
                              .apply(color: Theme.of(context).disabledColor)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.all(1.0),
                  child: IconButton(
                    onPressed: () {
                      resourceController.copyResourceURL(resource);
                      showToast(
                        'Link copied to the clipboard!',
                        context: context,
                        animation: StyledToastAnimation.slideFromBottom,
                        curve: Curves.decelerate,
                        reverseAnimation: StyledToastAnimation.fade,
                      );
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
    );
  }
}
