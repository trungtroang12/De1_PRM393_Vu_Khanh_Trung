// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RepoColor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(colorRepository)
final colorRepositoryProvider = ColorRepositoryProvider._();

final class ColorRepositoryProvider
    extends
        $FunctionalProvider<ColorRepository, ColorRepository, ColorRepository>
    with $Provider<ColorRepository> {
  ColorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorRepositoryHash();

  @$internal
  @override
  $ProviderElement<ColorRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ColorRepository create(Ref ref) {
    return colorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColorRepository>(value),
    );
  }
}

String _$colorRepositoryHash() => r'a73800a49e48c445bc7e06855a0aeca03432c071';
