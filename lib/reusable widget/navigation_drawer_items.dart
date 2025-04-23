import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class NavigationDrawerItems extends StatelessWidget {
  const NavigationDrawerItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color.fromRGBO(76, 175, 80, 1)),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: (){
              context.go('/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Report'),
            onTap: (){
              context.go('/report');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if(context.mounted){
                context.go('/');
              }
            },
          ),
          ListTile(
            title: Text('Test'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if(context.mounted){
                context.go('/test');
              }
            },
          ),
        ],
      ),
    );
  }
}
