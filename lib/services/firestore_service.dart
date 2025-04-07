import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // 🔹 Create (Add User)
  Future<DocumentReference<Object?>> addUser(String name, int age) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('data')
        .add({'name': name, 'age': age});
  }

  // 🔹 Read (Get All Users)
  Stream<List<Map<String, dynamic>>> getUsers() {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('data')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data =
                doc.data() as Map<String, dynamic>?; // Allow null values
            return {
              'id': doc.id,
              'name': data?['name'] ?? 'Unknown', // Default value for name
              'age': data?['age'] ?? 0, // Default value for age
            };
          }).toList();
        });
  }

  // 🔹 Update (Edit User)
  Future<void> updateUser(String userId, String name, int age) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('data')
        .doc(userId)
        .update({'name': name, 'age': age});
  }

  // 🔹 Delete (Remove User)
  Future<void> deleteUser(String userId) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('data')
        .doc(userId)
        .delete();
  }
}
