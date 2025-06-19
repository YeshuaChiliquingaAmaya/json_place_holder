import 'package:flutter/material.dart';
import 'package:json_place_holder/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: ListTile(
        leading: Checkbox(
          value: todo.completed,
          onChanged: null, // No editable en esta vista
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            fontStyle: todo.completed ? FontStyle.italic : null,
            color: todo.completed ? Colors.grey : null,
          ),
        ),
        trailing: todo.completed
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.pending, color: Colors.orange),
      ),
    );
  }
}
