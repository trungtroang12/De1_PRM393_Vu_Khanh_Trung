import 'package:flutter/material.dart';
import 'package:prm_final/Widgets/home_content.dart';
import 'package:prm_final/Widgets/color_picker.dart';
import 'package:prm_final/Screens/edit_task_page.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý công việc'),
        actions: const [ColorPicker()],
      ),
      body: SafeArea(
        child: HomeContent(
          onEdit: (task) => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditTaskPage(task: task)),
          ),
        ),
      ),
    );
  }
}
