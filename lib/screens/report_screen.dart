import 'dart:developer';

import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable widget/mainbar.dart';
import 'package:expenses_tracker_app/reusable widget/navigation_drawer_items.dart';
import 'package:expenses_tracker_app/reusable%20widget/expense_pie_chart.dart';
import 'package:expenses_tracker_app/reusable%20widget/expenses_table.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:expenses_tracker_app/services/crud_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final MenuController _filterDate = MenuController();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  DateTime? selectedMonth;
  String selectedCategory = 'All';

  final crudService = CrudService();

  final Map<String, Color> categoryColors = {
    'Food': Colors.green,
    'Transport': Colors.blue,
    'Rent': Colors.red,
    'Hobby': Colors.orange,
    'Health': Colors.yellow,
    'Other': Colors.purple,
  };

  final List<dynamic> tableHeader = [];

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showMonthPicker(
      context: context,
      initialDate: selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedMonth = DateTime(picked.year, picked.month);
      });
    }
  }

  Future<void> _downloadPdf(DateTime? selectedMonth, String? selectedCategory) async {
  final expenses = await crudService.getExpensesForMonthOnce(
    selectedMonth!,
    categoryFilter: selectedCategory,
  );

  log('[DEBUG] Expenses count: ${expenses.length}');

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Expense Report - ${selectedMonth.month}/${selectedMonth.year}',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headers: ['No', 'Name', 'Price', 'Qty', 'Total'],
              data: List.generate(expenses.length, (index) {
                final item = expenses[index];
                final name = item['name'] ?? '';
                final price = (item['price'] ?? 0).toDouble();
                final qty = (item['quantity'] ?? 1).toInt();
                final total = (price * qty).toStringAsFixed(2);
                return [
                  (index + 1).toString(),
                  name,
                  'RM ${price.toStringAsFixed(2)}',
                  qty.toString(),
                  'RM $total',
                ];
              }),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: MainBar(scaffoldKey: _scaffoldKey),
      drawer: NavigationDrawerItems(),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: mainBackGround,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('History', style: TextStyle(fontSize: 24)),
                IconButton(
                  onPressed: () async {
                    await _selectMonth(context);
                    setState(() {});
                    _filterDate.close();
                  },
                  icon: Icon(Icons.calendar_month_outlined),
                ),
              ],
            ),
            ExpensePieChart(selectedMonth: selectedMonth,selectedCategory:selectedCategory),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('List Expenses', style: TextStyle(fontSize: 24)),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onSelected: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(value: 'All', child: Text('All')),
                          const PopupMenuItem(
                            value: 'Food',
                            child: Text('Food'),
                          ),
                          const PopupMenuItem(
                            value: 'Transport',
                            child: Text('Transport'),
                          ),
                          const PopupMenuItem(
                            value: 'Rent',
                            child: Text('Rent'),
                          ),
                          const PopupMenuItem(
                            value: 'Hobby',
                            child: Text('Hobby'),
                          ),
                          const PopupMenuItem(
                            value: 'Health',
                            child: Text('Health'),
                          ),
                          const PopupMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                  ),
                ],
              ),
            ),
            ExpensesTable(selectedMonth: selectedMonth,selectedCategory:selectedCategory),

            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () { _downloadPdf(selectedMonth, selectedCategory);
                    log('Download pdf is clicked');},
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: buttonBackground,
                    ),
                    child: Text("Download"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
