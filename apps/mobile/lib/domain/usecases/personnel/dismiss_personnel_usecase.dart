import 'package:flutter_ios_android_platforms/core/network/api_response.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/personnel_repository.dart';

class DismissPersonnelUseCase {
  final PersonnelRepository repository;

  DismissPersonnelUseCase(this.repository);

  Future<ApiResponse<void>> call(String personnelId) async {
    return await repository.dismissPersonnel(personnelId);
  }
}
