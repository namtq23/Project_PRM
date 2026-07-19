// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_auth_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(googleAuthDataSource)
final googleAuthDataSourceProvider = GoogleAuthDataSourceProvider._();

final class GoogleAuthDataSourceProvider
    extends
        $FunctionalProvider<
          GoogleAuthDataSource,
          GoogleAuthDataSource,
          GoogleAuthDataSource
        >
    with $Provider<GoogleAuthDataSource> {
  GoogleAuthDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleAuthDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleAuthDataSourceHash();

  @$internal
  @override
  $ProviderElement<GoogleAuthDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GoogleAuthDataSource create(Ref ref) {
    return googleAuthDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleAuthDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleAuthDataSource>(value),
    );
  }
}

String _$googleAuthDataSourceHash() =>
    r'2c16a927228bf4e721cac9cc038609ffefd66126';
