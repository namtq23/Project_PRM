import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/presentation/view_models/auth_view_model.dart';
import '../../data/repositories/profile_repository.dart';
import '../../models/profile_model.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  Future<ProfileModel?> build() =>
      ref.watch(profileRepositoryProvider).getCurrentProfile();

  Future<bool> updateProfile({
    required String fullName,
    required String? phone,
    required String? avatarUrl,
  }) async {
    state = const AsyncLoading();
    try {
      final profile = await ref
          .read(profileRepositoryProvider)
          .updateProfile(
            fullName: fullName,
            phone: phone,
            avatarUrl: avatarUrl,
          );
      state = AsyncData(profile);
      await ref.read(authViewModelProvider.notifier).refreshCurrentUser();
      return true;
    } on ProfileException catch (error, stackTrace) {
      state = AsyncError(error.message, stackTrace);
      return false;
    } catch (error, stackTrace) {
      state = AsyncError(
        'Không thể cập nhật hồ sơ. Vui lòng thử lại.',
        stackTrace,
      );
      return false;
    }
  }
}
