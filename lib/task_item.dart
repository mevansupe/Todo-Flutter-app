import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/screens/add_edit_task_screen.dart';
import 'package:todoapp/tasks.dart' as tsk;
import 'package:todoapp/tasks.dart';

class TaskItem extends StatefulWidget {
  final tsk.TaskItem task;
  final bool all;

  TaskItem(this.task, this.all);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        if (!widget.task.completed) {
          Provider.of<Tasks>(context, listen: false).markAsComplete(widget.task.id);
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Task marked as completed!', textAlign: TextAlign.center,),
              duration: Duration(seconds: 2),
              action: widget.all ? SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  Provider.of<Tasks>(context, listen: false).markAsIncomplete(widget.task.id);
                },
              ) : null,
            ),
          );
        } else {
          Provider.of<Tasks>(context, listen: false).markAsIncomplete(widget.task.id);
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Task marked as Incomplete!', textAlign: TextAlign.center,),
              duration: Duration(seconds: 2),
              action: widget.all ? SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  Provider.of<Tasks>(context, listen: false).markAsComplete(widget.task.id);
                },
              ) : null,
            ),
          );
        }

        Navigator.of(context).pop();
      },
    );

    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title:  widget.task.completed ? Text("Incomplete") : Text("Complete"),
      content: widget.task.completed ? Text("Mark this task as incomplete?") : Text("Mark this task as completed?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      key: ValueKey(widget.task.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Tasks>(context, listen: false).removeItem(widget.task.id);
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Task Removed!', textAlign: TextAlign.center,),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: MaterialButton(
        onPressed: () {
          showAlertDialog(context);
        },
        child: Card(
          color: widget.task.completed ? Colors.grey : null,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
//              child: Padding(
//                padding: const EdgeInsets.all(3.0),
//                child: FittedBox(child: Text('\$$price')),
//              ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  child: Container(
                    color: widget.task.color,
                  ),
                ),
              ),
              title: Text(widget.task.task),
              subtitle: Text(DateFormat('dd-MM-yyyy').format(widget.task.dueDate) + ' Due'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditTaskScreen.routeName, arguments: widget.task.id);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
