import '../../../../../core/utils/either.dart';
import '../../data/model/profile_model.dart';

abstract class ProfileUseCase {
  Future<Either<Failure, ProfileModel>> getProfile();
}
