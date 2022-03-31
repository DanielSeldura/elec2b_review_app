import 'package:flutter/material.dart';

import '../screens/todos/todo_model.dart';

class TodoController with ChangeNotifier {
  List<Todo> data = [];

  toggleDone(Todo todo) {
    todo.toggleDone();
    notifyListeners();
  }

  addTodo(Todo todo) {
    data.add(todo);
    notifyListeners();
  }

  removeTodo(Todo toBeDeleted) {
    data.remove(toBeDeleted);
    notifyListeners();
  }

  updateTodo(Todo todo, String newDetails) {
    todo.updateDetails(newDetails);
    notifyListeners();
  }
}
