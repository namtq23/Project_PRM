import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/user_management_repository.dart';
import '../../models/user_management_model.dart';

part 'user_management_view_model.g.dart';

@riverpod
class UserManagementViewModel extends _$UserManagementViewModel {
  @override
  FutureOr<List<UserManagementModel>> build() async {
    final repository = ref.watch(userManagementRepositoryProvider);
    await repository.seedIfEmpty();
    return repository.getAllUsers();
  }

  Future<void> toggleUserStatus(int id, String currentStatus) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userManagementRepositoryProvider);
      final nextStatus = currentStatus == 'banned' ? 'active' : 'banned';
      await repository.updateUserStatus(id, nextStatus);
      return repository.getAllUsers();
    });
  }

  Future<void> changeUserRole(int id, String newRole) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userManagementRepositoryProvider);
      await repository.updateUserRole(id, newRole);
      return repository.getAllUsers();
    });
  }

  Future<void> deleteUser(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userManagementRepositoryProvider);
      await repository.deleteUser(id);
      return repository.getAllUsers();
    });
  }

  Future<void> createUser({
    required String fullName,
    required String email,
    required String role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(userManagementRepositoryProvider);
      final user = UserManagementModel(
        id: 0,
        fullName: fullName,
        email: email,
        role: role,
        status: 'active',
        createdAt: DateTime.now(),
        lastActivity: 'Active Now',
      );
      await repository.createUser(user);
      return repository.getAllUsers();
    });
  }
}
