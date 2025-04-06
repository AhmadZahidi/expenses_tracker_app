import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      context.go('/');
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(76, 175, 80, 1), Color.fromRGBO(76, 175, 80, 1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/Logo.svg",width: 200,height: 200,),
              SizedBox(height: 30),
              Text("SpendBuddy", style: TextStyle(color: Colors.white,fontSize: 24)),
              SizedBox(height: 30),
              Text("A mobile application to expenses tracker", style: TextStyle(color: Colors.white,fontSize: 12),),
            ],
          ),
        ),
      ),
    );
  }
}
