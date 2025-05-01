import 'package:expenses_tracker_app/services/crud_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListExpenses extends StatefulWidget {
  const ListExpenses({super.key, this.selectedMonth});

  final DateTime? selectedMonth;

  @override
  State<ListExpenses> createState() => _ListExpensesState();
}

class _ListExpensesState extends State<ListExpenses> {
  final crudService = CrudService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(  
      stream: widget.selectedMonth == null
          ? crudService.getExpenses()
          : crudService.getExpensesForMonth(widget.selectedMonth!),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final expenses = snapshot.data ?? [];

        return expenses.isEmpty
            ? const Center(child: Text("No expenses found"))
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final item = expenses[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      onTap: () {
                        context.push('/home/editDelete', extra: item);
                      },
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

