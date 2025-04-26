import 'package:expenses_tracker_app/services/crud_service.dart';
import 'package:flutter/material.dart';

class TotalExpenses extends StatefulWidget {
  TotalExpenses({
    super.key,
    required this.showAll,
    this.selectedMonth,
  });
  bool showAll;
  final DateTime? selectedMonth; 

  @override
  State<TotalExpenses> createState() => _TotalExpensesState();
}

class _TotalExpensesState extends State<TotalExpenses> {
  final crudService = CrudService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: crudService.getExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        final expenses = snapshot.data ?? [];
        
        final filteredExpenses =
            widget.showAll
                ? expenses
                : expenses.where((expense) {
                  final expenseDate = DateTime.parse(expense['date']);
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
