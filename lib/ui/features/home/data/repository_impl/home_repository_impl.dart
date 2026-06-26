import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/either.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/home_datasource.dart';
import '../datasource_impl/home_datasource_impl.dart';
import '../model/dashboard_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasource _datasource;

  HomeRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, DashboardModel>> getDashboard() =>
      _datasource.getDashboard();
}

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepositoryImpl(ref.read(homeDatasourceProvider)),
);
