// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bucket _$BucketFromJson(Map<String, dynamic> json) => Bucket(
      id: json['id'] as String,
      name: json['name'] as String,
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String?,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      dateUpdated: DateTime.parse(json['dateUpdated'] as String),
    );

Map<String, dynamic> _$BucketToJson(Bucket instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'users': instance.users,
      'resources': instance.resources,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'dateUpdated': instance.dateUpdated.toIso8601String(),
    };
