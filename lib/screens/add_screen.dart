import 'package:expenses_tracker_app/reusable%20widget/crudbar.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget{
  const AddScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Crudbar('Add Expenses'),
    );
  }
}