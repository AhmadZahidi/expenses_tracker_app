import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable%20widget/list_expenses.dart';
import 'package:expenses_tracker_app/reusable%20widget/mainBar.dart';
import 'package:expenses_tracker_app/reusable%20widget/navigation_drawer_items.dart';
import 'package:expenses_tracker_app/reusable%20widget/total_expenses.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MenuController _filterMenuContoller = MenuController();

  DateTime? selectedMonth;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //appbar
      appBar: MainBar(scaffoldKey: _scaffoldKey),
      drawer: NavigationDrawerItems(),

      //background color
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
          //start of content
          child: Column(
            children: [
              //show total expenses
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0.0,
                  vertical: 8.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    child: Center(
                      child: TotalExpenses(selectedMonth: selectedMonth),
                    ),
                  ),
                ),
              ),

              //button for add and camera icon
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {
                        context.push('/home/add');
                      },
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: buttonBackground,
                      ),
                      child: Text("Add"),
                    ),
                    SizedBox(width: 36),
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: buttonBackground,
                      ),
                      child: Icon(Icons.camera_alt),
                    ),
                  ],
                ),
              ),

              //second row title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Expenses List", style: TextStyle(fontSize: 24)),

                  IconButton(
                    onPressed: () async {
                      await _selectMonth(context);
                      setState(() {});
                      _filterMenuContoller.close();
                    },
                    icon: Icon(Icons.calendar_month_outlined),
                  ),
                ],
              ),

              //content
              Expanded(child: ListExpenses(selectedMonth: selectedMonth)),
            ],
          ),
        ),
      ),
    );
  }
}
