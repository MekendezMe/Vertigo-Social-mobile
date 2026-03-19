import 'package:dio/dio.dart';
import 'package:social_network_flutter/common/framework/storages/secure_storage.dart';

class LauncherRepository {
  final ISecureStorage secureStorage;
  final Dio dio;

  LauncherRepository({required this.secureStorage, required this.dio});
  Future<String?> getAccessToken() async {
    final response = await dio.post(
      '/refresh',
      data: {'refresh_token': secureStorage.refreshToken},
    );
    if (response.data is! Map ||
        !(response.data as Map<String, dynamic>).containsKey("access_token")) {
      return null;
    }

    return response.data['access_token'];
  }
}
