import 'package:shared_preferences/shared_preferences.dart';

class Database {
  final Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
}
