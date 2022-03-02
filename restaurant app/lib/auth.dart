
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late int recentCost;

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

  Stream<QuerySnapshot> getStatus() {
    var ref = _firestore.collection("tables").snapshots();
    return ref;
  }

  Stream<QuerySnapshot> getProducts() {
    var ref = _firestore.collection("products").snapshots();
    return ref;
  }


  Future<void> removeStatus(String docId) {
    var ref = _firestore.collection("tables").doc(docId).delete();

    return ref;
  }

  Future<User?> addProduct(String productName, int productCost) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    productName = productName.toUpperCase();

    if (productName != "" && productCost != "") {
      await _firestore.collection('products').doc(productName).set({
        'ProductName': productName,
        'ProductCost': productCost,
      }).catchError((dynamic onError) {
        _buildErrorMessage(onError.message);
      });
    } else {
      _buildErrorMessage("Verileri boşluksuz giriniz!");
    }
  }

  Future<User?> updateTable(String Id, String postId, int cost) async {
    if (Id != "") {
      await _firestore.collection("tables").doc(postId).get().then((value) {
        recentCost = value.data()!["Cost"];
      });

      await _firestore.collection('tables').doc(postId).update({
        'Products': FieldValue.arrayUnion([Id]),
        "Cost": cost + recentCost
      }).catchError((dynamic onError) {
        _buildErrorMessage(onError.message);
      });
    } else {
      _buildErrorMessage("Verileri boşluksuz giriniz!");
    }
  }

  Future<User?> createTable(String tableNumber) async {
    if (tableNumber != "") {
      await _firestore.collection('tables').doc(tableNumber).set({
        "Desk Number": tableNumber,
        "Products": "",
        "Cost": 0,
      }).catchError((dynamic onError) {
        _buildErrorMessage(onError.message);
      });
    } else {
      _buildErrorMessage("Verileri boşluksuz giriniz!");
    }
  }
}
