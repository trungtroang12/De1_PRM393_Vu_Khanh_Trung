// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ColorViewModel)
final colorViewModelProvider = ColorViewModelProvider._();

final class ColorViewModelProvider
    extends $AsyncNotifierProvider<ColorViewModel, String> {
  ColorViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorViewModelHash();

  @$internal
  @override
  ColorViewModel create() => ColorViewModel();
}

String _$colorViewModelHash() => r'061699cac6b95799be09bcad2385a139446adfa3';

abstract class _$ColorViewModel extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
