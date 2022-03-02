import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:tinderclone/main-page.dart';
import 'package:tinderclone/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

LoginScreen sa = LoginScreen();
MainPage s = MainPage();

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String a = "asb";
  int storageIndex = 0;
  late List<String> sas;
  String? imgUrl;
  String? imgUrl2;

  void _buildErrorMessage(String text) {
    Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.red,
        fontSize: 14);
  }
  
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("An error occured while trying to send email verification");
    }
  }

  //giriş yap fonksiyonu
  Future<String?> getData() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    await _firestore
        .collection("Person")
        .doc(firebaseUser?.uid)
        .get()
        .then((value) {

      a = value.data()!["userName"];
    });
    print("*/////////////////*******" + a);
  }

  Future<String?> downloadURLExample() async {
    storage.ListResult result = await storage.FirebaseStorage.instance
        .ref('images/')
        .list(storage.ListOptions(maxResults: 100));
    print(result.items[storageIndex].name);
    storageIndex++;
    imgUrl = result.items[storageIndex].fullPath.characters.toString();
    print("---------------------" + imgUrl.toString());

    String downloadURL = await storage.FirebaseStorage.instance
        .ref(imgUrl.toString())
        .getDownloadURL();

    imgUrl2 = downloadURL;
    print(imgUrl2);
  }

  //Giriş Yapma
  Future<User?> signIn(String email, String password) async {
    var user = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((dynamic error) {
      _buildErrorMessage(error.message);

      print(error.message);
    });

    return user.user;
  }

  //Kayıt Olma
  Future<User?> createPerson(String name, String email, String password) async {
    var user = await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((dynamic error) {
      _buildErrorMessage(error.message);

      print(error.message);
    });

    await _firestore
        .collection("Person")
        .doc(user.user!.uid)
        .set({'userName': name, 'email': email});

    return user.user;
  }
}
