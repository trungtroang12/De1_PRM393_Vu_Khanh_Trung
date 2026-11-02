import 'package:flutter/material.dart';

import 'package:prm_final/data/models/Task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;

  const TaskWidget({super.key, required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(task.description),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Chỉnh sửa ${task.title}',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
