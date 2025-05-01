import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker_app/services/crud_service.dart';
import 'package:flutter/material.dart';

class TotalExpenses extends StatefulWidget {
  TotalExpenses({super.key, this.selectedMonth});

  final DateTime? selectedMonth;

  @override
  State<TotalExpenses> createState() => _TotalExpensesState();
}

class _TotalExpensesState extends State<TotalExpenses> {
  final crudService = CrudService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream:
          widget.selectedMonth == null
              ? crudService.getExpenses()
              : crudService.getExpensesForMonth(widget.selectedMonth!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        final expenses = snapshot.data ?? [];

        final filteredExpenses =
            widget.selectedMonth == null
                ? expenses
                : expenses.where((expense) {
                  final expenseDate =
                      (expense['date'] as Timestamp)
                          .toDate(); // Use toDate() if it's a Timestamp
                  return expenseDate.year == widget.selectedMonth?.year &&
                      expenseDate.month == widget.selectedMonth?.month;
                }).toList();

        double total = 0;
        for (var expense in filteredExpenses) {
          final price = (expense['price'] ?? 0).toDouble();
          final quantity = (expense['quantity'] ?? 1).toInt();
          total += price * quantity;
        }

        return Text(
          "RM ${total.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        );
      },
    );
  }
}
