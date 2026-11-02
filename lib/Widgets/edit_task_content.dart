import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:prm_final/data/models/Task.dart';
import 'package:prm_final/ViewModel/task_view_model.dart';

class EditTaskContent extends ConsumerStatefulWidget {
  final Task task;

  const EditTaskContent({super.key, required this.task});

  @override
  ConsumerState<EditTaskContent> createState() => _EditTaskContentState();
}

class _EditTaskContentState extends ConsumerState<EditTaskContent> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late bool completed;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    completed = widget.task.completed;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> saveTask() async {
    if (!formKey.currentState!.validate()) return;
    final task = widget.task.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      completed: completed,
    );
    setState(() => saving = true);
    try {
      final viewModel = ref.read(taskViewModelProvider.notifier);
      await viewModel.updateTask(task);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không lưu được công việc')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Tiêu đề *'),
          const SizedBox(height: 8),
          TextFormField(
            controller: titleController,
            enabled: !saving,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nhập tiêu đề công việc';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          const Text('Mô tả'),
          const SizedBox(height: 8),
          TextFormField(
            controller: descriptionController,
            enabled: !saving,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Đã hoàn thành'),
            value: completed,
            onChanged: saving
                ? null
                : (value) => setState(() => completed = value),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: saving ? null : () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: saving ? null : saveTask,
                  child: const Text('Lưu'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
