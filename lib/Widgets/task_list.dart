import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prm_final/data/models/Task.dart';
import 'package:prm_final/Widgets/task_widget.dart';

class TaskList extends StatelessWidget {
  final AsyncValue<List<Task>> tasks;
  final ValueChanged<Task> onEdit;

  const TaskList({super.key, required this.tasks, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return tasks.when(
      data: (items) => ListView(
        padding: const EdgeInsets.all(8),
        children: [
          for (final task in items)
            TaskWidget(
              key: ValueKey(task.id),
              task: task,
              onEdit: () => onEdit(task),
            ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const Center(child: Text('Không tải được công việc')),
    );
  }
}
