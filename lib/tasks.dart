import 'package:flutter/cupertino.dart';

class TaskItem {
  final String id;
  final String task;
  final Color color;
  final DateTime createdAt;
  final DateTime dueDate;
  final bool completed;

  TaskItem({
    @required this.id,
    @required this.task,
    @required this.color,
    this.createdAt,
    @required this.dueDate,
    this.completed = false
  });
}

class Tasks with ChangeNotifier {
  List<TaskItem> _items = [
    TaskItem(
        id: 't1',
        task: 'Test Task',
        color: Color(0xff4caf50),
        createdAt: DateTime.now(),
        dueDate: DateTime.now()),
    TaskItem(
        id: 't2',
        task: 'Test Task 2',
        color: Color(0xff4caf50),
        createdAt: DateTime.now(),
        dueDate: DateTime.now()),
  ];

  List<TaskItem> get items {
    return [..._items];
  }

  List<TaskItem> get incompleteTasks {
    return _items.where((taskItem) => !taskItem.completed).toList();
  }

  List<TaskItem> get completedTasks {
    return _items.where((taskItem) => taskItem.completed).toList();
  }

  void addProduct(TaskItem taskItem) async {
    try {
      final newTask = TaskItem(
        id: DateTime.now().toString(),
        task: taskItem.task,
        color: taskItem.color,
        createdAt: DateTime.now(),
        dueDate: taskItem.dueDate,
      );
      _items.insert(0, newTask);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  TaskItem findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  void markAsComplete(String id) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      _items[itemIndex] = new TaskItem(
          id: _items[itemIndex].id,
          task: _items[itemIndex].task,
          color: _items[itemIndex].color,
          dueDate: _items[itemIndex].dueDate,
          completed: true);
      notifyListeners();
    } else {
      print("Error");
    }
  }

  void markAsIncomplete(String id) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      _items[itemIndex] = new TaskItem(
          id: _items[itemIndex].id,
          task: _items[itemIndex].task,
          color: _items[itemIndex].color,
          dueDate: _items[itemIndex].dueDate,
          completed: false);
      notifyListeners();
    } else {
      print("Error");
    }
  }

  void updateProduct(String id, TaskItem taskItem) {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      _items[itemIndex] = taskItem;
      notifyListeners();
    } else {
      print("Error");
    }
  }

  void removeItem(String id) {
    final existingTaskIndex = _items.indexWhere((prod) => prod.id == id);
    _items.removeAt(existingTaskIndex);
    notifyListeners();
  }
}
