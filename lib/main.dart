import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/screens/add_edit_task_screen.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/home_screen_completed.dart';
import 'package:todoapp/screens/home_screen_incompleted.dart';
import 'package:todoapp/screens/splash_screen.dart';
import 'package:todoapp/tasks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Tasks(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          HomeScreenCompleted.routeName: (ctx) => HomeScreenCompleted(),
          HomeScreenIncompleted.routeName: (ctx) => HomeScreenIncompleted(),
          EditTaskScreen.routeName: (ctx) => EditTaskScreen(),
        },
      ),
    );
  }
}