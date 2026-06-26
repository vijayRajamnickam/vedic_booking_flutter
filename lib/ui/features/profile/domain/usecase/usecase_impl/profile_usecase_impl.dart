import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/utils/either.dart';
import '../../../data/model/profile_model.dart';
import '../../../data/repository_impl/profile_repository_impl.dart';
import '../../repository/profile_repository.dart';
import '../profile_usecase.dart';

class ProfileUseCaseImpl implements ProfileUseCase {
  final ProfileRepository _repo;
  ProfileUseCaseImpl(this._repo);

  @override
  Future<Either<Failure, ProfileModel>> getProfile() => _repo.getProfile();
}

final profileUseCaseProvider = Provider<ProfileUseCase>(
  (ref) => ProfileUseCaseImpl(ref.read(profileRepositoryProvider)),
);
