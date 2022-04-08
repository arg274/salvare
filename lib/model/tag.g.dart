// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as int,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => Resource.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateUpdated: DateTime.parse(json['dateUpdated'] as String),
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'resources': instance.resources != null
          ? instance.resources!.map((e) => e.toJson()).toList()
          : instance.resources,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'dateUpdated': instance.dateUpdated.toIso8601String(),
    };
