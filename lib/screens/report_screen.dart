import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable widget/mainbar.dart';
import 'package:expenses_tracker_app/reusable widget/navigation_drawer_items.dart';
import 'package:expenses_tracker_app/reusable%20widget/expense_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  final Map<String, Color> categoryColors = {
    'Food': Colors.green,
    'Transport': Colors.blue,
    'Rent': Colors.red,
    'Hobby': Colors.orange,
    'Health': Colors.yellow,
    'Other': Colors.purple,
  };

  final List<dynamic> tableHeader = [];

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
                  onPressed: () {},
                  icon: Icon(Icons.calendar_month_outlined),
                ),
              ],
            ),
            ExpensePieChart(),
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
            StreamBuilder(
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
            ),
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
