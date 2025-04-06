import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // 🔹 Create (Add User)
  Future<DocumentReference<Object?>> addUser(String name, int age) async {
    return await users.add({'name': name, 'age': age});
  }

  // 🔹 Read (Get All Users)
Stream<List<Map<String, dynamic>>> getUsers() {
  return users.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>?; // Allow null values
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
    return await users.doc(userId).update({'name': name, 'age': age});
  }

  // 🔹 Delete (Remove User)
  Future<void> deleteUser(String userId) async {
    return await users.doc(userId).delete();
  }
}
