import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListExpenses extends StatefulWidget {
  const ListExpenses({super.key});

  @override
  State<ListExpenses> createState() => _ListExpensesState();
}

class _ListExpensesState extends State<ListExpenses> {
  final ScrollController _scrollController = ScrollController();
  final int _itemsPerPage = 10;
  List<Map<String, dynamic>> _expenses = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMoreExpenses();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && !_isLoading && _hasMore) {
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
    final newExpenses = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    setState(() {
      _isLoading = false;
      _expenses.addAll(newExpenses);
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
    return _expenses.isEmpty && _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            // shrinkWrap: true,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: _expenses.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _expenses.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = _expenses[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  title: Text(item['name'] ?? 'Unnamed'),
                  subtitle: Text("Quantity: ${item['quantity'] ?? '-'}"),
                  trailing: Text("RM ${item['price'] ?? '-'}"),
                ),
              );
            },
          );
  }
}
