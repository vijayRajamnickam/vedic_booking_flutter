import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/either.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasource/profile_datasource.dart';
import '../datasource_impl/profile_datasource_impl.dart';
import '../model/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource _ds;
  ProfileRepositoryImpl(this._ds);

  @override
  Future<Either<Failure, ProfileModel>> getProfile() => _ds.getProfile();
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.read(profileDatasourceProvider)),
);
