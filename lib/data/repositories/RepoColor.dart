import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'RepoColor.g.dart';

abstract class ColorRepository {
  Future<String> getColor();
  Future<void> saveColor(String color);
}

class LocalColorRepository implements ColorRepository {
  final _preferences = SharedPreferencesAsync();

  @override
  Future<String> getColor() async {
    final color = await _preferences.getString('app_bar_color') ?? 'green';
    if (color == 'green' || color == 'blue' || color == 'purple') {
      return color;
    }
    return 'green';
  }

  @override
  Future<void> saveColor(String color) async {
    await _preferences.setString('app_bar_color', color);
  }
}

@Riverpod(keepAlive: true)
ColorRepository colorRepository(Ref ref) => LocalColorRepository();
