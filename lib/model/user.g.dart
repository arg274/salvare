// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      userName: json['userName'] as String,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      description: json['description'] as String?,
      buckets:
          (json['buckets'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'dob': instance.dob?.toIso8601String(),
      'description': instance.description,
      'buckets': instance.buckets,
      'dateCreated': instance.dateCreated.toIso8601String(),
    };
