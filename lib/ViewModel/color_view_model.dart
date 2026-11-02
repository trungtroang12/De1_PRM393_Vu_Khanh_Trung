import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:prm_final/data/repositories/RepoColor.dart';

part 'color_view_model.g.dart';

@Riverpod(keepAlive: true)
class ColorViewModel extends _$ColorViewModel {
  @override
  Future<String> build() {
    final repository = ref.watch(colorRepositoryProvider);
    return repository.getColor();
  }

  Future<void> selectColor(String color) async {
    final repository = ref.read(colorRepositoryProvider);
    await repository.saveColor(color);
    state = AsyncData(color);
  }
}
