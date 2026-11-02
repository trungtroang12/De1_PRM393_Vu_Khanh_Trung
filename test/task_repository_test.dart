import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:prm_final/data/repositories/RepoTask.dart';

void main() {
  late Directory directory;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('prm_final_sqlite_');
    await databaseFactoryFfi.setDatabasesPath(directory.path);
  });

  tearDown(() async {
    await databaseFactoryFfi.deleteDatabase(join(directory.path, 'tasks.db'));
    await directory.delete();
  });

  test('new database has four columns and keeps saved changes', () async {
    final repository = LocalTaskRepository();
    final db = await repository.database;
    addTearDown(db.close);

    final columns = await db.rawQuery('PRAGMA table_info(tasks)');
    expect(columns.map((column) => column['name']).toList(), [
      'id',
      'title',
      'description',
      'completed',
    ]);
    expect(await db.getVersion(), 2);

    final tasks = await repository.getTasks();
    expect(tasks.map((task) => task.title).toList(), [
      'Làm bài tập Flutter',
      'Ôn tập Riverpod',
      'Chuẩn bị bài thuyết trình',
      'Viết báo cáo môn học',
    ]);
    final edited = tasks.first.copyWith(
      title: 'Công việc đã sửa',
      description: 'Mô tả mới',
      completed: true,
    );
    await repository.updateTask(edited);
    await db.close();

    final reopened = LocalTaskRepository();
    final reopenedDb = await reopened.database;
    addTearDown(reopenedDb.close);
    final saved = await reopened.getTasks();
    expect(saved.length, 4);
    expect(saved.first.toJson(), edited.toJson());
  });

  test('version 1 upgrade removes icon and keeps existing tasks', () async {
    final oldDb = await databaseFactoryFfi.openDatabase(
      join(directory.path, 'tasks.db'),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE tasks (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              completed INTEGER NOT NULL DEFAULT 0,
              icon TEXT NOT NULL
            )
          ''');
          await db.insert('tasks', {
            'id': 7,
            'title': 'Công việc của tớ',
            'description': 'Nội dung đã sửa',
            'completed': 1,
            'icon': 'book',
          });
          await db.insert('tasks', {
            'id': 12,
            'title': 'Việc chưa hoàn thành',
            'description': '',
            'completed': 0,
            'icon': 'report',
          });
        },
      ),
    );
    await oldDb.close();

    final repository = LocalTaskRepository();
    final db = await repository.database;
    addTearDown(db.close);
    final tasks = await repository.getTasks();
    expect(tasks.map((task) => task.toJson()).toList(), [
      {
        'id': 7,
        'title': 'Công việc của tớ',
        'description': 'Nội dung đã sửa',
        'completed': 1,
      },
      {
        'id': 12,
        'title': 'Việc chưa hoàn thành',
        'description': '',
        'completed': 0,
      },
    ]);
    final columns = await db.rawQuery('PRAGMA table_info(tasks)');
    expect(columns.map((column) => column['name']), isNot(contains('icon')));
    expect(await db.getVersion(), 2);
    expect(
      await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE name = 'tasks_old'",
      ),
      isEmpty,
    );

    final edited = tasks.last.copyWith(title: 'Đã cập nhật', completed: true);
    await repository.updateTask(edited);
    await db.close();
    final reopened = LocalTaskRepository();
    final reopenedDb = await reopened.database;
    addTearDown(reopenedDb.close);
    final saved = await reopened.getTasks();
    expect(saved.length, 2);
    expect(saved.first.toJson(), tasks.first.toJson());
    expect(saved.last.toJson(), edited.toJson());
  });
}
