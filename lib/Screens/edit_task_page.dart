import 'package:flutter/material.dart';

import 'package:prm_final/data/models/Task.dart';
import 'package:prm_final/Widgets/edit_task_content.dart';

class EditTaskPage extends StatelessWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa công việc'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(child: EditTaskContent(task: task)),
    );
  }
}
