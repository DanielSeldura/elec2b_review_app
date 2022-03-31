import 'package:flutter/material.dart';

import '../todo_model.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final Function()? onErase;
  final Function()? onTap;
  final Function()? onLongPress;
  final EdgeInsets? margin;
  final ScrollController _sc = ScrollController();

  TodoCard(
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
                Expanded(
                  child: Scrollbar(
                    controller: _sc,
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      controller: _sc,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        todo.details,
                        style: TextStyle(
                            decoration:
                                todo.done ? TextDecoration.lineThrough : null),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
