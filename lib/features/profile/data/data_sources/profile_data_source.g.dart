// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_data_source.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileDataSource)
final profileDataSourceProvider = ProfileDataSourceProvider._();

final class ProfileDataSourceProvider
    extends
        $FunctionalProvider<
          ProfileDataSource,
          ProfileDataSource,
          ProfileDataSource
        >
    with $Provider<ProfileDataSource> {
  ProfileDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProfileDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileDataSource create(Ref ref) {
    return profileDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileDataSource>(value),
    );
  }
}

String _$profileDataSourceHash() => r'c399870b3d0807c9c96e2edfddd462239382816f';
