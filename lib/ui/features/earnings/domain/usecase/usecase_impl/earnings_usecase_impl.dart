import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/utils/either.dart';
import '../../../data/model/earnings_model.dart';
import '../../../data/repository_impl/earnings_repository_impl.dart';
import '../../repository/earnings_repository.dart';
import '../earnings_usecase.dart';

class EarningsUseCaseImpl implements EarningsUseCase {
  final EarningsRepository _repo;
  EarningsUseCaseImpl(this._repo);

  @override
  Future<Either<Failure, EarningsModel>> getEarnings() => _repo.getEarnings();
}

final earningsUseCaseProvider = Provider<EarningsUseCase>(
  (ref) => EarningsUseCaseImpl(ref.read(earningsRepositoryProvider)),
);
