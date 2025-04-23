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
                      radius: 90,
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList();

              final firstHalf =
                  categoryColors.entries
                      .take((categoryColors.length / 2).ceil())
                      .toList();

              final secondHalf =
                  categoryColors.entries
                      .skip((categoryColors.length / 2).ceil())
                      .toList();

              return Card(
                elevation: 8,
                margin: EdgeInsets.symmetric(vertical: 16,),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  3.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Center vertically
                    children: [
                      // First half
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            firstHalf
                                .map(
                                  (entry) => _categoryFirstHalf(
                                    entry.value,
                                    entry.key,
                                  ),
                                )
                                .toList(),
                      ),

                      // Pie Chart
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: sections,
                          ),
                        ),
                      ),

                      // Second half
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children:
                            secondHalf
                                .map(
                                  (entry) => _categorySecondHalf(entry.value, entry.key),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _categoryFirstHalf(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 56,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }
}

Widget _categorySecondHalf(Color color, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(text, style: const TextStyle(color: Colors.black, fontSize: 14)),
      const SizedBox(width: 8),
      Container(
        width: 16,
        height: 56,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      
    ],
  );
}
