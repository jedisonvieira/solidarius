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
          .then((user) => {userData = user.data()});
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

      loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void loadCurrentUser() {
    if (firebaseUser == null) {
      firebaseUser = _auth.currentUser!;
    } else {
      if (userData!["name"] == null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser!.uid)
            .get()
            .then((user) => {userData = user.data()});
      }
    }

    notifyListeners();
  }

  Future<void> logOut() async {
    await _auth.signOut();
    firebaseUser = null;
    notifyListeners();
  }

  Future<String?> getUserAvatar(String? id) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    return UserData.fromDocument(userSnapshot).avatar;
  }

  void recoverPass() {}
}
