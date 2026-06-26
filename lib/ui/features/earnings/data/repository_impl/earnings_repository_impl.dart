import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/either.dart';
import '../../domain/repository/earnings_repository.dart';
import '../datasource/earnings_datasource.dart';
import '../datasource_impl/earnings_datasource_impl.dart';
import '../model/earnings_model.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  final EarningsDatasource _ds;
  EarningsRepositoryImpl(this._ds);

  @override
  Future<Either<Failure, EarningsModel>> getEarnings() => _ds.getEarnings();
}

final earningsRepositoryProvider = Provider<EarningsRepository>(
  (ref) => EarningsRepositoryImpl(ref.read(earningsDatasourceProvider)),
);
