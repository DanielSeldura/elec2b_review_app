import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../screens/todos/todo_model.dart';

class TodoController with ChangeNotifier {
  final Box todoCache = Hive.box('todos');
  late String currentUser;
  List<Todo> data = [];

  TodoController(this.currentUser) {
    List result = todoCache.get(currentUser, defaultValue: []);
    print(result);
    for (var entry in result) {
      print(entry);
      data.add(Todo.fromJson(Map<String, dynamic>.from(entry)));
    }
    notifyListeners();
  }

  toggleDone(Todo todo) {
    todo.toggleDone();
    saveDataToCache();
  }

  addTodo(Todo todo) {
    data.add(todo);
    saveDataToCache();
  }

  removeTodo(Todo toBeDeleted) {
    data.remove(toBeDeleted);
    saveDataToCache();
  }

  updateTodo(Todo todo, String newDetails) {
    todo.updateDetails(newDetails);
    saveDataToCache();
  }

  saveDataToCache() {
    List<Map<String, dynamic>> dataToStore = [];
    for (Todo todo in data) {
      dataToStore.add(todo.toJson());
    }
    print(dataToStore);
    todoCache.put(currentUser, dataToStore);
    notifyListeners();
  }
}
