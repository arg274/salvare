import 'package:json_annotation/json_annotation.dart';

part 'bucket.g.dart';

@JsonSerializable()
class Bucket {
  String id;
  String name;
  String? description;
  List<String> users;
  DateTime dateCreated;
  DateTime dateUpdated;

  Bucket(
      {required this.id,
      required this.name,
      required this.users,
      this.description,
      required this.dateCreated,
      required this.dateUpdated});

  // Named constructor that forwards to the default one.
  Bucket.unlaunched(String id, String name, String user)
      : this(
            id: id,
            name: name,
            users: [user],
            dateCreated: DateTime.now(),
            dateUpdated: DateTime.now());

  void addUser(String userId) => users.add(userId);

  factory Bucket.fromJson(Map<String, dynamic> json) => _$BucketFromJson(json);

  Map<String, dynamic> toJson() => _$BucketToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
