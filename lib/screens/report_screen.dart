import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable widget/mainbar.dart';
import 'package:expenses_tracker_app/reusable widget/navigation_drawer_items.dart';
import 'package:expenses_tracker_app/reusable%20widget/expense_pie_chart.dart';
import 'package:expenses_tracker_app/reusable%20widget/expenses_table.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final MenuController _filterDate = MenuController();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  DateTime? selectedMonth;
  bool filterByMonth = true;

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
        filterByMonth = false;
      });
    }
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
                MenuAnchor(
                  controller: _filterDate,
                  builder: (context, controller, child) {
                    return IconButton(
                      onPressed: () {
                        controller.isOpen
                            ? controller.close()
                            : controller.open();
                      },
                      icon: Icon(Icons.calendar_month_outlined),
                    );
                  },
                  menuChildren: [
                    MenuItemButton(
                      onPressed: () {
                        setState(() {
                          filterByMonth = true;
                        });
                        _filterDate.close();
                      },
                      child: Text('Show All'),
                    ),
                    MenuItemButton(
                      onPressed: () async {
                        await _selectMonth(context);
                        setState(() {
                          filterByMonth = false;
                        });
                        _filterDate.close();
                      },
                      child: Text('By Month'),
                    ),
                  ],
                ),
              ],
            ),
            ExpensePieChart(filterByMonth:filterByMonth ,selectedMonth: selectedMonth,),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('List Expenses', style: TextStyle(fontSize: 24)),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
            ),
            ExpensesTable(),

            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    onPressed: () {},
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
