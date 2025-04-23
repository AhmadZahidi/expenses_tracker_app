import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable widget/mainbar.dart';
import 'package:expenses_tracker_app/reusable widget/navigation_drawer_items.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Define category-color mapping
  final Map<String, Color> categoryColors = {
    'Food': Colors.green,
    'Transport': Colors.blue,
    'Rent': Colors.red,
    'Hobby': Colors.orange,
    'Health': Colors.yellow,
    'Other': Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: MainBar(scaffoldKey: _scaffoldKey),
      drawer: NavigationDrawerItems(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: mainBackGround,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
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

              // Calculate totals per category
              Map<String, double> categoryTotals = {};
              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final category = data['category'] ?? 'Other';
                final price = (data['price'] ?? 0).toDouble();
                final quantity = (data['quantity'] ?? 1).toInt();

                categoryTotals[category] =
                    (categoryTotals[category] ?? 0) + (price * quantity);
              }

              // Generate PieChartSectionData
              final totalExpense = categoryTotals.values.fold(
                0.0,
                (sum, value) => sum + value,
              );

              final sections =
                  categoryTotals.entries.where((e) => e.value > 0).map((entry) {
                    final percentage = (entry.value / totalExpense * 100)
                        .toStringAsFixed(1);
                    return PieChartSectionData(
                      value: entry.value,
                      color: categoryColors[entry.key] ?? Colors.grey,
                      title: '$percentage%',
                      radius: 100,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList();

              return Column(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children:
                        categoryColors.entries.map((entry) {
                          return _category(entry.value, entry.key);
                        }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: sections,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _category(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }
}
