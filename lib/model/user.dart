import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String id;
  String userName;
  DateTime? dob;
  String? description;
  List<String>? buckets;
  DateTime dateCreated;

  User(
      {required this.id,
      required this.userName,
      this.dob,
      this.description,
      this.buckets,
      required this.dateCreated});

  // Named constructor that forwards to the default one.
  User.unlaunched(String id, String userName)
      : this(id: id, userName: userName, dateCreated: DateTime.now());

  void addBucket(String bucketId) {
    if (buckets != null) {
      buckets!.add(bucketId);
    } else {
      buckets = [bucketId];
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
