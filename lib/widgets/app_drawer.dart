import 'package:flutter/material.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/home_screen_completed.dart';
import 'package:todoapp/screens/home_screen_incompleted.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Welcome'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.work),
            title: Text('All'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.circle),
            title: Text('Incomplete'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreenIncompleted.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.check),
            title: Text('Completed'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreenCompleted.routeName);
            },
          ),
        ],
      ),
    );
  }
}
