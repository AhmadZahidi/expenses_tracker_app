import 'package:flutter/material.dart';

class Crudbar extends StatelessWidget implements PreferredSizeWidget {
  const Crudbar(this.screenTitle, {super.key});

  final String screenTitle;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); 

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(76, 175, 80, 1),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
        color: Colors.white,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 8),
          Text(screenTitle, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
