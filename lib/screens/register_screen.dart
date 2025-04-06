import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen ({super.key});

  @override
  State<StatefulWidget> createState(){
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen>{
  @override
  Widget build(BuildContext context) {
    return Text("Register Screen");
  }
}