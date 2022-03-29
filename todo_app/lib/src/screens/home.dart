import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [
    Todo(
      id: 1,
      details: 'Walk the goldfish',
    ),
  ];

  final ScrollController _sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos App'),
        backgroundColor: const Color(0xFF303030),
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
        child: Padding(
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
                        for (Todo todo in todos)
                          TodoCard(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            todo: todo,
                            onTap: () {
                              toggleDone(todo);
                            },
                            onErase: () {
                              removeTodo(todo);
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
        ),
      ),
    );
  }

  toggleDone(Todo todo) {
    if (mounted) {
      setState(() {
        todo.toggleDone();
      });
    }
  }

  addTodo(Todo todo) {
    if (mounted) {
      setState(() {
        todos.add(todo);
      });
    }
  }

  removeTodo(Todo toBeDeleted) {
    todos.remove(toBeDeleted);
    setState(() {});
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
      addTodo(result);
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
      if (mounted) {
        setState(() {
          todo.updateDetails(result.details);
        });
      }
    }
  }
}

class InputWidget extends StatefulWidget {
  final String? current;
  const InputWidget({this.current, Key? key}) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final TextEditingController _tCon = TextEditingController();
  String? get current => widget.current;
  @override
  void initState() {
    if (current != null) _tCon.text = current as String;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        onChanged: () {
          _formKey.currentState?.validate();
          setState(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(current != null ? 'Edit Todo' : 'Add new Todo'),
            TextFormField(
              controller: _tCon,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: (_formKey.currentState?.validate() ?? false)
                  ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop(Todo(details: _tCon.text));
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  primary: (_formKey.currentState?.validate() ?? false)
                      ? const Color(0xFF303030)
                      : Colors.grey),
              child: Text(current != null ? 'Edit' : 'Add'),
            )
          ],
        ),
      ),
    );
  }
}

class Todo {
  String details;
  late DateTime created;
  bool done = false;
  int id;

  Todo({this.details = '', DateTime? created, this.id = 0}) {
    created == null ? this.created = DateTime.now() : this.created = created;
  }

  String get parsedDate {
    return Moment.fromDateTime(created).format('hh:mm a MMMM dd, yyyy ');
  }

  updateDetails(String update) {
    details = update;
    created = DateTime.now();
  }

  toggleDone() {
    done = !done;
  }
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  final Function()? onErase;
  final Function()? onTap;
  final Function()? onLongPress;
  final EdgeInsets? margin;
  const TodoCard(
      {required this.todo,
      this.onTap,
      this.onLongPress,
      this.onErase,
      this.margin,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AspectRatio(
          aspectRatio: 11 / 3,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.zero),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      todo.parsedDate,
                      style: TextStyle(
                          decoration:
                              todo.done ? TextDecoration.lineThrough : null),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close),
                      iconSize: 20,
                      onPressed: onErase,
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            todo.details,
                            style: TextStyle(
                                decoration: todo.done
                                    ? TextDecoration.lineThrough
                                    : null),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
