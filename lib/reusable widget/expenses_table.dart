import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpensesTable extends StatefulWidget{
  const ExpensesTable({super.key});

  @override
  State<StatefulWidget> createState()=>_ExpensesTableState();
}

class _ExpensesTableState extends State<ExpensesTable>{
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('expenses')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final docs = snapshot.data?.docs ?? [];

                return Expanded(
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Card(
                        child: DataTable(
                          columnSpacing: 70,
                          columns: const [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Price')),
                          ],
                          rows:
                              docs.asMap().entries.map((entry) {
                                final index = entry.key + 1;
                                final data =
                                    entry.value.data() as Map<String, dynamic>;

                                final name = data['name'] ?? '';
                                final price = (data['price'] ?? 0).toDouble();
                                final quantity =
                                    (data['quantity'] ?? 1).toInt();
                                final total = price * quantity;

                                return DataRow(
                                  cells: [
                                    DataCell(Text(index.toString())),
                                    DataCell(Text(name)),
                                    DataCell(
                                      Text('RM ${total.toStringAsFixed(2)}'),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
  }
}