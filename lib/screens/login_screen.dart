import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            children: [
              SvgPicture.asset("assets/images/Logo.svg", width: 100, height: 100),
              SizedBox(height: 30),
              Text(
                "SpendBuddy",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 60),
              Text("Email", style: TextStyle(color: Colors.white, fontSize: 12)),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'test ',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
