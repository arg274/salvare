import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/resource.dart';
import 'package:salvare/database/database_paths.dart';

class DashboardController {
  Stream<QuerySnapshot<Resource>> getResourceStream() {
    return FireStoreDB().getResourceStreamDB();
  }
}
