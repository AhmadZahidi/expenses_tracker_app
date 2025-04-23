import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable%20widget/mainbar.dart';
import 'package:expenses_tracker_app/reusable%20widget/navigation_drawer_items.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget{
  const ReportScreen({super.key});

  @override
  State<StatefulWidget> createState()=> _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>{
  @override
  Widget build(BuildContext context) {
      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          child: Column()),
    ));
  }
}