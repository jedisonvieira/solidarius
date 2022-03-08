import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:solidarius/shared/datas/user_data.dart';

class UserModel extends Model {
  User? firebaseUser;
  bool isLoading = false;
  Map<String, dynamic>? userData = {};
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isUserLogged() {
    if (_auth.currentUser != null) {
      firebaseUser = _auth.currentUser;
      FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser!.uid)
          .get()
          .then((user) => userData = user.data());
    }
    return _auth.currentUser != null;
  }

  void signUp(
      {required Map<String, dynamic> userData,
      required String pass,
      required VoidCallback onSuccess,
      required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();

    _auth
        .createUserWithEmailAndPassword(
            email: userData["email"], password: pass)
        .then((createdUser) async {
      firebaseUser = createdUser.user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .set(userData);
  }

  Future<void> updateUser(Map<String, dynamic> userData) async {
    firebaseUser = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .update(userData);
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
        .then((loggedUser) async {
      firebaseUser = loggedUser.user;

      await loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser!;
    } else {
      userData!["id"] = firebaseUser!.uid;
      if (userData!["name"] == null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser!.uid)
            .get()
            .then((user) => userData = user.data());
      }
    }

    notifyListeners();
  }

  Future<void> logOut() async {
    userData = {};
    firebaseUser = null;
    await _auth.signOut();
    notifyListeners();
  }

  Future<String?> getUserAvatar(String? id) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    return UserData.fromDocument(userSnapshot).avatar;
  }

  void recoverPass() {}
}
