// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resource _$ResourceFromJson(Map<String, dynamic> json) => Resource(
      json['id'] as String,
      json['title'] as String,
      json['url'] as String,
      json['category'] as String,
      (json['tags'] as List<dynamic>?)
          ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['description'] as String,
      DateTime.parse(json['dateCreated'] as String),
      DateTime.parse(json['dateUpdated'] as String),
      json['imageUrl'] as String?,
    );

Map<String, dynamic> _$ResourceToJson(Resource instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'category': instance.category,
      'tags': instance.tags != null
          ? instance.tags!.map((e) => e.toJson()).toList()
          : instance.tags,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'dateUpdated': instance.dateUpdated.toIso8601String(),
    };
