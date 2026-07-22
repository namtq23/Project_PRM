import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/preferences_service.dart';
import '../../models/profile_model.dart';
import '../data_sources/profile_data_source.dart';

part 'profile_repository.g.dart';

abstract interface class ProfileRepository {
  Future<ProfileModel?> getCurrentProfile();

  Future<ProfileModel> updateProfile({
    required String fullName,
    required String? phone,
    required String? avatarUrl,
  });
}

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this.dataSource, this.preferencesService);

  final ProfileDataSource dataSource;
  final PreferencesService preferencesService;

  @override
  Future<ProfileModel?> getCurrentProfile() async {
    final userId = await preferencesService.getCurrentUserId();
    return userId == null ? null : dataSource.getProfile(userId);
  }

  @override
  Future<ProfileModel> updateProfile({
    required String fullName,
    required String? phone,
    required String? avatarUrl,
  }) async {
    final userId = await preferencesService.getCurrentUserId();
    if (userId == null) {
      throw const ProfileException('Phiên đăng nhập đã hết hạn.');
    }
    try {
      return await dataSource.updateProfile(
        userId: userId,
        fullName: fullName,
        phone: phone,
        avatarUrl: avatarUrl,
      );
    } on ProfileDataException {
      throw const ProfileException('Không thể cập nhật hồ sơ.');
    }
  }
}

class ProfileException implements Exception {
  const ProfileException(this.message);
  final String message;
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepositoryImpl(
  ref.watch(profileDataSourceProvider),
  ref.watch(preferencesServiceProvider),
);
