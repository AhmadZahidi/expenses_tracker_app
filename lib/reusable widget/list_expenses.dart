import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker_app/services/crud_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ListExpenses extends StatefulWidget {
  const ListExpenses({super.key});

  @override
  State<ListExpenses> createState() => _ListExpensesState();
}

class _ListExpensesState extends State<ListExpenses> {
  final crudService = CrudService();

  final ScrollController _scrollController = ScrollController();
  final int _itemsPerPage = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreExpenses();
      }
    });
  }

  Future<void> _loadMoreExpenses() async {
    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses')
        .orderBy('date', descending: true)
        .limit(_itemsPerPage);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();
    final newExpenses =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    setState(() {
      _isLoading = false;
      if (newExpenses.length < _itemsPerPage) {
        _hasMore = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: crudService.getExpenses(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final expenses = snapshot.data ?? [];

        return expenses.isEmpty
            ? const Center(child: Text("No expenses found"))
            : ListView.builder(
              padding: EdgeInsets.only(bottom: 16),
                controller: _scrollController,
                itemCount: expenses.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == expenses.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final item = expenses[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text(item['name'] ?? 'Unnamed'),
                      subtitle: Text("Quantity: ${item['quantity'] ?? '-'}"),
                      trailing: Text("RM ${item['price'] ?? '-'}"),
                    ),
                  );
                },
              );
      },
    );
  }
}
