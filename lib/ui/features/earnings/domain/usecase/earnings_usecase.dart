import '../../../../../core/utils/either.dart';
import '../../data/model/earnings_model.dart';

abstract class EarningsUseCase {
  Future<Either<Failure, EarningsModel>> getEarnings();
}
