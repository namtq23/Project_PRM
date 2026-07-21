// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserManagementViewModel)
final userManagementViewModelProvider = UserManagementViewModelProvider._();

final class UserManagementViewModelProvider
    extends
        $AsyncNotifierProvider<
          UserManagementViewModel,
          List<UserManagementModel>
        > {
  UserManagementViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userManagementViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userManagementViewModelHash();

  @$internal
  @override
  UserManagementViewModel create() => UserManagementViewModel();
}

String _$userManagementViewModelHash() =>
    r'c1d1b2bb76945f715f92d0536329fa5135c53eb2';

abstract class _$UserManagementViewModel
    extends $AsyncNotifier<List<UserManagementModel>> {
  FutureOr<List<UserManagementModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<UserManagementModel>>,
              List<UserManagementModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserManagementModel>>,
                List<UserManagementModel>
              >,
              AsyncValue<List<UserManagementModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
