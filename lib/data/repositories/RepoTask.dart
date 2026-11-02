import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

import 'package:prm_final/data/models/Task.dart';

part 'RepoTask.g.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<void> updateTask(Task task);
}

class LocalTaskRepository implements TaskRepository {
  late final Future<Database> database = _openDatabase();

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        completed INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<Database> _openDatabase() async {
    final databasePath = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      databasePath,
      version: 2,
      onCreate: (db, version) async {
        await _createTable(db);
        final tasks = [
          const Task(
            id: 1,
            title: 'Làm bài tập Flutter',
            description: 'Hoàn thành trước thứ Sáu',
            completed: false,
          ),
          const Task(
            id: 2,
            title: 'Ôn tập Riverpod',
            description: 'Xem lại bài giảng MVVM',
            completed: false,
          ),
          const Task(
            id: 3,
            title: 'Chuẩn bị bài thuyết trình',
            description: 'Nhóm 4 - Chủ đề Firebase',
            completed: false,
          ),
          const Task(
            id: 4,
            title: 'Viết báo cáo môn học',
            description: 'Nộp trên LMS',
            completed: false,
          ),
        ];
        for (final task in tasks) {
          await db.insert('tasks', task.toJson());
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE tasks RENAME TO tasks_old');
          await _createTable(db);
          await db.execute('''
            INSERT INTO tasks (id, title, description, completed)
            SELECT id, title, description, completed FROM tasks_old
          ''');
          await db.execute('DROP TABLE tasks_old');
        }
      },
    );
  }

  @override
  Future<List<Task>> getTasks() async {
    final db = await database;
    final rows = await db.query('tasks', orderBy: 'id');
    final tasks = <Task>[];
    for (final row in rows) {
      tasks.add(Task.fromJson(row));
    }
    return tasks;
  }

  @override
  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) => LocalTaskRepository();
