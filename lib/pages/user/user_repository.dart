import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class UserRepository extends Model {
  /*UserModel? user;
  User? firebaseUser;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void singUp(
      {required UserModel user,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(email: user.email, password: pass)
        .then((userSaved) async {
      firebaseUser = userSaved.user;

      await saveUser(user);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void singIn(
      {required String email,
      required String password,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((SignedUser) async {
      firebaseUser = SignedUser.user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _loadCurrentUser() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      firebaseUser = currentUser;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> saveUser(UserModel user) async {
    this.user = user;
    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(firebaseUser!.uid)
        .set(user.toMap(user));
  }

  bool isUserLogged() {
    return firebaseUser != null;
  }*/
}
