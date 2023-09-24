import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase/authentication.dart';
import '../../../services/firebase/firestore_services.dart';

class GroceryListViewModel {
  final firebaseAuth = Authentication(FirebaseAuth.instance);
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController();
  final imageUrlController = TextEditingController();
  final groceryFormkey = GlobalKey<FormState>();

  Stream<QuerySnapshot> getGroceryStream() {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.getCurrentUserUid())
        .collection('groceries')
        .snapshots();
  }

  Future<void> addGrocery() async {
    final fireStoreService =
        FireStoreServices(userUid: firebaseAuth.getCurrentUserUid() ?? '');
    fireStoreService.addGrocery(nameController.text, descriptionController.text,
        quantityController.text, imageUrlController.text);
  }
}
