import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/tasks.dart';

class EditTaskScreen extends StatefulWidget {
  static const routeName = '/view-task';

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _form = GlobalKey<FormState>();
  var _editTask = TaskItem(id: null, task: null, color: null,  dueDate: DateTime.now(), completed: false);
  var _isInit = true;
  var _initValues = {
    'id': '',
    'task': '',
    'color': '',
    'dueDate': '',
    'completed': false,
  };

  var _isLoading = false;
  var _isCompleted= false;
  // create some values
  Color pickerColor = Color(0xff4caf50);
  Color currentColor = Color(0xff4caf50);

  DateTime selectedDate = DateTime.now();

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final taskId = ModalRoute
          .of(context)
          .settings
          .arguments as String;
      if (taskId != null) {
        _editTask =
            Provider.of<Tasks>(context, listen: false).findById(taskId);
        _initValues = {
          'task': _editTask.task,
          'color': _editTask.color,
          'dueDate': _editTask.dueDate,
          'completed': _editTask,
        };
        setState(() {
          currentColor = _editTask.color;
          selectedDate = _editTask.dueDate;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    if (_editTask.id != null) {
      await Provider.of<Tasks>(context, listen: false).updateProduct(_editTask.id, _editTask);
    } else {
      try {
        _editTask = TaskItem(
          id: _editTask.id,
          task: _editTask.task,
          dueDate: _editTask.dueDate,
          color: pickerColor,
          completed: _editTask.completed,
          createdAt: _editTask.createdAt,
        );
        await Provider.of<Tasks>(context, listen: false).addProduct(_editTask);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) =>
              AlertDialog(
                title: Text('An error occurred'),
                content: Text('Somthing went wrong'),
                actions: [
                  FlatButton(onPressed: () {
                    Navigator.of(ctx).pop();
                  }, child: Text('Okay'))
                ],
              ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _editTask = TaskItem(
        id: _editTask.id,
        task: _editTask.task,
        dueDate: picked,
        color: _editTask.color,
        completed: _editTask.completed,
        createdAt: _editTask.createdAt,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['task'],
                decoration: InputDecoration(
                  labelText: 'Task',
                ),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editTask = TaskItem(
                      id: _editTask.id,
                      task: value,
                      dueDate: _editTask.dueDate,
                      color: _editTask.color,
                      completed: _editTask.completed,
                      createdAt: _editTask.createdAt,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a Task';
                  }
                  return null;
                },
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Text("Due Date: "),
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                children: [
                  Text("Completed: "),
                  Switch(value: _editTask.completed, onChanged: (value) {
                    _editTask = TaskItem(
                      id: _editTask.id,
                      task: _editTask.task,
                      dueDate: _editTask.dueDate,
                      color: _editTask.color,
                      completed: value,
                      createdAt: _editTask.createdAt,
                    );
                    setState(() {
                      _isCompleted = _editTask.completed;
                    });
                  }),
                ],
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                        showDialog(
                          context: context,
                          child: AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  _editTask = TaskItem(
                                    id: _editTask.id,
                                    task: _editTask.task,
                                    dueDate: _editTask.dueDate,
                                    color: pickerColor,
                                    completed: _editTask.completed,
                                    createdAt: _editTask.createdAt,
                                  );
                                  setState(() => currentColor = pickerColor);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Container(
                        height: 50,
                          width: 50,
                          color: currentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
