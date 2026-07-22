// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileViewModel)
final profileViewModelProvider = ProfileViewModelProvider._();

final class ProfileViewModelProvider
    extends $AsyncNotifierProvider<ProfileViewModel, ProfileModel?> {
  ProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileViewModelHash();

  @$internal
  @override
  ProfileViewModel create() => ProfileViewModel();
}

String _$profileViewModelHash() => r'2d6016d87965ab8e05287c1da7f7142a09ef44e8';

abstract class _$ProfileViewModel extends $AsyncNotifier<ProfileModel?> {
  FutureOr<ProfileModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ProfileModel?>, ProfileModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProfileModel?>, ProfileModel?>,
              AsyncValue<ProfileModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
