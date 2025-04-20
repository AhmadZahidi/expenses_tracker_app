import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CrudService {
  Future<DocumentReference<Object?>>? addExpense(
    String name,
    String category,
    String desc,
    double price,
    int quantity,
    DateTime date,
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
            'desc':desc,
            'price': price,
            'quantity': quantity,
            'date': date.toIso8601String(),
          });
    } catch (e) {
      print("Error add expenses:$e");
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

}
