import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreServices {
  FireStoreServices({required this.userUid});
  final String userUid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser() async {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': 'Banana',
      'description': 'Ripe Banana',
      'quantity': '10 pcs.',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg',
    };

    final DocumentReference documentReferencer = _firestore
        .collection('user')
        .doc(userUid)
        .collection('groceries')
        .doc();

    await documentReferencer.set(data).whenComplete(() {
      if (kDebugMode) {
        print('User added to the database');
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    });
  }

  Future<void> addGrocery(
      String name, String description, String quantity, String imageUrl) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'name': name,
      'description': description,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };

    final DocumentReference documentReferencer = _firestore
        .collection('user')
        .doc(userUid)
        .collection('groceries')
        .doc();

    await documentReferencer.set(data).whenComplete(() {
      if (kDebugMode) {
        print('grocery added to the database');
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    });
  }
}
