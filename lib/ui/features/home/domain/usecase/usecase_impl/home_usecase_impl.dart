import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/utils/either.dart';
import '../../../data/model/dashboard_model.dart';
import '../../../data/repository_impl/home_repository_impl.dart';
import '../../repository/home_repository.dart';
import '../home_usecase.dart';

class HomeUseCaseImpl implements HomeUseCase {
  final HomeRepository _repository;

  HomeUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, DashboardModel>> getDashboard() =>
      _repository.getDashboard();
}

final homeUseCaseProvider = Provider<HomeUseCase>(
  (ref) => HomeUseCaseImpl(ref.read(homeRepositoryProvider)),
);
