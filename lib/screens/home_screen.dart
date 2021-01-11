import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/screens/add_edit_task_screen.dart';
import 'package:todoapp/task_item.dart' as tsk;
import 'package:todoapp/widgets/app_drawer.dart';

import '../tasks.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<Tasks>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: tasks.items.length,
                itemBuilder: (ctx, i) => tsk.TaskItem(tasks.items[i], true),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditTaskScreen.routeName);
        },
        tooltip: 'New',
        child: Icon(Icons.add),
      ), // Th
      drawer: AppDrawer(),// is trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
