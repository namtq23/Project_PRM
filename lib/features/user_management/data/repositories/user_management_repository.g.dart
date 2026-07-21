// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_management_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userManagementRepository)
final userManagementRepositoryProvider = UserManagementRepositoryProvider._();

final class UserManagementRepositoryProvider
    extends
        $FunctionalProvider<
          UserManagementRepository,
          UserManagementRepository,
          UserManagementRepository
        >
    with $Provider<UserManagementRepository> {
  UserManagementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userManagementRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userManagementRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserManagementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserManagementRepository create(Ref ref) {
    return userManagementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserManagementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserManagementRepository>(value),
    );
  }
}

String _$userManagementRepositoryHash() =>
    r'369d5ac98b4ebcbecd269f98617960c699c8fbb5';
