import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app/constants.dart';

class DBServices {
  createOrUpdateDocument(String path, Map<String, dynamic> data) async {
    await db.doc(path).set(data, SetOptions(merge: true)).onError((e, s) {
      debugPrint('error in creating document $e');
    });
  }
}
