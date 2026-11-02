import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:prm_final/data/models/Task.dart';
import 'package:prm_final/data/repositories/RepoTask.dart';

part 'task_view_model.g.dart';

@riverpod
class TaskViewModel extends _$TaskViewModel {
  @override
  Future<List<Task>> build() {
    final repository = ref.watch(taskRepositoryProvider);
    return repository.getTasks();
  }

  Future<void> updateTask(Task task) async {
    final repository = ref.read(taskRepositoryProvider);
    await repository.updateTask(task);
    final tasks = await repository.getTasks();
    state = AsyncData(tasks);
  }
}
