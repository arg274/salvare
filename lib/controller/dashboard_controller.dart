import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salvare/database/firestore_db.dart';
import 'package:salvare/model/resource.dart';

class DashboardController {
  Stream<QuerySnapshot<Resource>> getResourceStream() {
    return FireStoreDB().getResourceStreamDB();
  }
}
