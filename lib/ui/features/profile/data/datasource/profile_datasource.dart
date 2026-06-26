import '../../../../../core/utils/either.dart';
import '../model/profile_model.dart';

abstract class ProfileDatasource {
  Future<Either<Failure, ProfileModel>> getProfile();
}
