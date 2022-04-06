import 'package:flutter/material.dart';
import 'package:todo_app/src/controllers/todo_controller.dart';
import 'package:todo_app/src/screens/login/auth_controller.dart';
import 'package:todo_app/src/screens/todos/todo_model.dart';
import 'package:todo_app/src/screens/todos/widgets/input_widget.dart';
import 'package:todo_app/src/screens/todos/widgets/todo_card.dart';

class TodoScreen extends StatefulWidget {
  final AuthController auth;
  const TodoScreen(this.auth, {Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late TodoController _todoController;
  final ScrollController _sc = ScrollController();
  AuthController get _auth => widget.auth;
  @override
  void initState() {
    _todoController = TodoController(_auth.currentUser!.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos App'),
        backgroundColor: const Color(0xFF303030),
        actions: [
          IconButton(
              onPressed: () {
                _auth.logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF303030),
        child: const Icon(Icons.add),
        onPressed: () {
          showAddDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _todoController,
          builder: (context, Widget? w) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: Scrollbar(
                      controller: _sc,
                      isAlwaysShown: true,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(12.0),
                        controller: _sc,
                        child: Column(
                          children: [
                            for (Todo todo in _todoController.data)
                              TodoCard(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                todo: todo,
                                onTap: () {
                                  _todoController.toggleDone(todo);
                                },
                                onErase: () {
                                  _todoController.removeTodo(todo);
                                },
                                onLongPress: () {
                                  showEditDialog(context, todo);
                                },
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  showAddDialog(BuildContext context) async {
    Todo? result = await showDialog<Todo>(
        context: context,
        //if you don't want issues on navigator.pop, rename the context in the builder to something other than context
        builder: (dContext) {
          return const Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: InputWidget(),
          );
        });
    if (result != null) {
      _todoController.addTodo(result);
    }
  }

  showEditDialog(BuildContext context, Todo todo) async {
    Todo? result = await showDialog<Todo>(
        context: context,
        //if you don't want issues on navigator.pop, rename the context in the builder to something other than context
        builder: (dContext) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: InputWidget(
              current: todo.details,
            ),
          );
        });
    if (result != null) {
      _todoController.updateTodo(todo, result.details);
    }
  }
}
