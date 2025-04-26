import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
