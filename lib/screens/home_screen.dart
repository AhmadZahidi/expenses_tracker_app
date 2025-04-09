import 'package:expenses_tracker_app/background_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
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
      ),

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
              Text("RM total expenses"),

              //button for add and camera icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      backgroundColor: buttonBackground,
                    ),
                    child: Text("Add"),
                  ),
                  SizedBox(width: 36,),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                      backgroundColor: buttonBackground,
                    ),
                    child: Icon(Icons.camera_alt),
                  ),
                ],
              ),

              //second row title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Expenses List",style: TextStyle(fontSize: 24),),
                  IconButton(onPressed: (){}, icon: Icon(Icons.filter_list))
                ],
              ),

              //content

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(8),
                
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text("item"),
                  Text("price")
                ],)
              ),

            ],
          ),
        ),
      ),
    );
  }
}
