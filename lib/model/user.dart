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

void main() {
  try {
    User user1 = User.unlaunched('1', 'nono');
    print(user1);
    User user3 = User.fromJson(user1.toJson());
    print(DateTime.parse(user3.dateCreated.toString()).year);
    Map<String, dynamic> userMap2 = user1.toJson();
    print('Howdy1, ${userMap2['buckets']}');
    user1.addBucket('addedBucket1');
    user1.addBucket('addedBucket2');
    print('Hello $user1');
    Map<String, dynamic> json = user1.toJson();
    print('json = $json');
    User user2 = User.fromJson(json);
    print('user2: $user2');
    //print(DateTime.parse(user2.dateCreated.toString()).year);
    Map<String, dynamic> userMap = user1.toJson();
    print('Howdy2, ${userMap['buckets']}');
  } catch (e) {
    print(e);
  }
}
