import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CrudService {
  Future<DocumentReference<Object?>>? addExpense(
    String name,
    String category,
    String desc,
    double price,
    int quantity,
    DateTime date,
    String? imageUrl,
  ) {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .add({
            'name': name,
            'category': category,
            'desc': desc,
            'price': price,
            'quantity': quantity,
            'date': date.toIso8601String(),
            'imageUrl': imageUrl,
          });
    } catch (e) {
      print("Error adding expense: $e");
      return null;
    }
  }

  Stream<List<Map<String, dynamic>>> getExpenses() {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => {
                      'id': doc.id,
                      ...doc.data() as Map<String, dynamic>,
                    },
                  )
                  .toList(),
        );
  }

  Future<void> deleteExpense(String id) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .doc(id)
          .delete();
    } catch (e) {
      log("Error deleting expense: $e");
    }
  }

  Future<void> updateExpense(
    String id,
    Map<String, dynamic> updateItems,
  ) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses')
          .doc(id)
          .update({
            'name': updateItems['name'],
            'category': updateItems['category'],
            'price': updateItems['price'],
            'quantity': updateItems['quantity'],
            'date':
                updateItems['date'] is DateTime
                    ? (updateItems['date'] as DateTime).toIso8601String()
                    : updateItems['date'],
            'desc': updateItems['desc'],
            'imageUrl':updateItems['imageUrl']
          });
    } catch (e) {
      log("Error updateing expense: $e");
    }
  }

  //   Future<void> updateExpense() async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('expenses')
  //         .doc(widget.expenseData['id']) // assuming 'id' is the document ID
  //         .update({
  //       'name': nameController.text,
  //       'quantity': int.tryParse(quantityController.text) ?? 0,
  //       'price': double.tryParse(priceController.text) ?? 0.0,
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Expense updated successfully')),
  //     );

  //     Navigator.pop(context); // Go back after updating
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to update: $e')),
  //     );
  //   }
  // }

  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_receipts')
          .child(uid)
          .child('$fileName.jpg');

      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
