import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable%20widget/mainbar.dart';
import 'package:expenses_tracker_app/reusable%20widget/navigation_drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: MainBar(scaffoldKey: _scaffoldKey),
      drawer: NavigationDrawerItems(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: mainBackGround,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Expense Distribution',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                        setState(() {
                          touchedIndex = response?.touchedSection?.touchedSectionIndex;
                        });
                      },
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 0,
                    sections: [
                      PieChartSectionData(
                        value: 40,
                        color: Colors.blueAccent,
                        title: 'Food',
                        radius: touchedIndex == 0 ? 45 : 100,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 30,
                        color: Colors.greenAccent,
                        title: 'Transport',
                        radius: touchedIndex == 1 ? 45 : 100,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: Colors.orangeAccent,
                        title: 'Bills',
                        radius: touchedIndex == 2 ? 45 : 100,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: 10,
                        color: Colors.purpleAccent,
                        title: 'Others',
                        radius: touchedIndex == 3 ? 45 : 100,
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Legend
              Wrap(
                spacing: 20,
                runSpacing: 10,
                children: [
                  _buildLegend(Colors.blueAccent, 'Food'),
                  _buildLegend(Colors.greenAccent, 'Transport'),
                  _buildLegend(Colors.orangeAccent, 'Bills'),
                  _buildLegend(Colors.purpleAccent, 'Others'),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}