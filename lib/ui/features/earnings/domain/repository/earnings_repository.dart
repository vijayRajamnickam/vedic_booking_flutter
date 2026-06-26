import '../../../../../core/utils/either.dart';
import '../../data/model/earnings_model.dart';

abstract class EarningsRepository {
  Future<Either<Failure, EarningsModel>> getEarnings();
}
