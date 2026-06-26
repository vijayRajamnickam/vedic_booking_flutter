import '../../../../../core/utils/either.dart';
import '../../data/model/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getProfile();
}
