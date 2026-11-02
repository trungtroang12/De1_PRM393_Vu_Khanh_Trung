import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prm_final/data/models/Task.dart';
import 'package:prm_final/ViewModel/task_view_model.dart';
import 'package:prm_final/Widgets/task_list.dart';

class HomeContent extends ConsumerWidget {
  final ValueChanged<Task> onEdit;

  const HomeContent({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskViewModelProvider);
    return TaskList(tasks: tasks, onEdit: onEdit);
  }
}
