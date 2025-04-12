import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainBar extends StatelessWidget implements PreferredSizeWidget {
  const MainBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromRGBO(76, 175, 80, 1),
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu),
        color: Colors.white,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: SvgPicture.asset(
              "assets/images/Logo.svg",
              height: 24,
              width: 24,
            ),
          ),

          SizedBox(width: 8),
          Text("SpendBuddy", style: TextStyle(color: Colors.white)),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.question_mark),
          color: Colors.white,
        ),
      ],
    );
  }
}
