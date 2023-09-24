import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_training_basic/services/firebase/firestore_services.dart';

class Authentication {
  Authentication(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Future<String?> login(String username, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: username, password: password);

      if (userCredential.user != null) {
        return 'success';
      } else {
        return 'Something went wrong!';
      }
    } on FirebaseAuthException catch (e) {
      print('error: ${e.code}');
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return 'No user found with this email or password.';
      } else if (e.code == 'too-many-requests' ||
          e.code == 'operation-not-allowed') {
        return 'Too many failed login attempts. Please try again later.';
      } else if (e.code == 'invalid-email' || e.code == 'unknown') {
        return 'field-error';
      } else {
        return e.message;
      }
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        if (userCredential.user?.uid != null) {
          FireStoreServices(userUid: userCredential.user!.uid).addUser();
        }
        return 'success';
      } else {
        return 'Something went wrong!';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Something went wrong!';
    }
  }

  String? getCurrentUserUid() {
    final User? authUser = _firebaseAuth.currentUser;
    if (authUser == null) {
      return null;
    }
    return authUser.uid;
  }
}
