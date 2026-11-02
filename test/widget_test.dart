import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm_final/main.dart';
import 'package:prm_final/data/models/Task.dart';
import 'package:prm_final/data/repositories/RepoTask.dart';
import 'package:prm_final/data/repositories/RepoColor.dart';
import 'package:prm_final/Widgets/task_widget.dart';

class TestTasks extends TaskRepository {
  List<Task> tasks = [
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
  ];

  @override
  Future<List<Task>> getTasks() async => List.of(tasks);

  @override
  Future<void> updateTask(Task task) async {
    tasks = [
      for (final item in tasks)
        if (item.id == task.id) task else item,
    ];
  }
}

class TestColors implements ColorRepository {
  String selected = 'green';

  @override
  Future<String> getColor() async => selected;

  @override
  Future<void> saveColor(String color) async {
    selected = color;
  }
}

void main() {
  testWidgets(
    'list, edit, validate, save, cancel and remembered app bar color',
    (tester) async {
      final tasks = TestTasks();
      final colors = TestColors();
      ProviderContainer createContainer() => ProviderContainer(
        overrides: [
          taskRepositoryProvider.overrideWithValue(tasks),
          colorRepositoryProvider.overrideWithValue(colors),
        ],
      );
      var container = createContainer();
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const MyApp()),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TaskWidget), findsNWidgets(2));
      expect(find.byType(Icon), findsNWidgets(3));
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byIcon(Icons.delete), findsNothing);
      await tester.tap(find.byTooltip('Chỉnh sửa Làm bài tập Flutter'));
      await tester.pumpAndSettle();
      expect(find.text('Chỉnh sửa công việc'), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);
      await tester.enterText(find.byType(TextFormField).first, '  ');
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();
      expect(find.text('Nhập tiêu đề công việc'), findsOneWidget);
      await tester.enterText(
        find.byType(TextFormField).first,
        'Bài tập đã sửa',
      );
      await tester.enterText(find.byType(TextFormField).last, 'Mô tả mới');
      await tester.tap(find.byType(SwitchListTile));
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();
      expect(find.text('Bài tập đã sửa'), findsOneWidget);
      expect(tasks.tasks.first.completed, isTrue);
      expect(tasks.tasks.first.description, 'Mô tả mới');
      await tester.tap(find.byTooltip('Chỉnh sửa Bài tập đã sửa'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Không lưu');
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();
      expect(find.text('Bài tập đã sửa'), findsOneWidget);
      expect(tasks.tasks.first.title, 'Bài tập đã sửa');
      final originalColorScheme = Theme.of(tester.element(find.byType(AppBar)))
          .colorScheme;
      for (final option in {
        'Xanh dương': Colors.blue,
        'Tím': Colors.purple,
        'Xanh lá': Colors.green,
      }.entries) {
        await tester.tap(find.byTooltip('Chọn màu thanh ứng dụng'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(option.key));
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(AppBar));
        expect(Theme.of(context).appBarTheme.backgroundColor, option.value);
        expect(Theme.of(context).colorScheme, originalColorScheme);
      }
      await tester.tap(find.byTooltip('Chọn màu thanh ứng dụng'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tím'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      container = createContainer();
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const MyApp()),
      );
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(AppBar)))
            .appBarTheme
            .backgroundColor,
        Colors.purple,
      );
      expect(find.text('Bài tập đã sửa'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
    },
  );
}
