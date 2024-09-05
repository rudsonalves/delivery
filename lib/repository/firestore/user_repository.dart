import '../../common/models/user.dart';
import '../../common/utils/data_result.dart';

abstract class UserRepository {
  Future<DataResult<UserModel>> set(UserModel user);
  Future<void> setEmailVerification(String userId, bool emailVerified);
  Future<DataResult<UserModel>> update(UserModel user);
  Future<DataResult<void>> delete(String userId);
  Future<DataResult<UserModel?>> get(UserModel user);
}
