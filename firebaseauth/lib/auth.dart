import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showErrorMessage(String text) {
    Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.red,
        fontSize: 14);
  }

  Future<User?> signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((dynamic error) {
      _showErrorMessage(error.message);
    });
  }

  Future<User?> createPerson(
      String email, String password, String userName) async {
    if (email != "" && password != "" && userName != "") {
      var user = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError((dynamic error) {
        _showErrorMessage(error.message);
      });

      await _firestore.collection("users").doc(user.user!.uid).set({
        "Email": email,
        "UserName": userName,
      }).catchError((dynamic onError) {
        _showErrorMessage(onError.message);
      });
    } else {
      _showErrorMessage("Bilgileri eksiksiz doldurun!");
    }
  }
}
