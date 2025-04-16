import 'package:expenses_tracker_app/services/crud_service.dart';
import 'package:flutter/material.dart';

class TotalExpenses extends StatefulWidget {
  const TotalExpenses({super.key});

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

        double total = 0;
        for (var expense in expenses) {
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
