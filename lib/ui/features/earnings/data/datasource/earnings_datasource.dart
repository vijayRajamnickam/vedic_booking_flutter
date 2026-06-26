import '../../../../../core/utils/either.dart';
import '../model/earnings_model.dart';

abstract class EarningsDatasource {
  Future<Either<Failure, EarningsModel>> getEarnings();
}
