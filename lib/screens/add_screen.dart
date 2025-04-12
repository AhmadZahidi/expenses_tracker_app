import 'package:expenses_tracker_app/background_color.dart';
import 'package:expenses_tracker_app/reusable%20widget/background_screen.dart';
import 'package:expenses_tracker_app/reusable%20widget/crudbar.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget{
  const AddScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BackgroundScreen(appBar:Crudbar('Add Expenses'),backgroundColor:mainBackGround, screen:Column());
  }
}