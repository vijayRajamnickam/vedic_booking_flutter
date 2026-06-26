import '../../../../../core/utils/either.dart';
import '../model/dashboard_model.dart';

abstract class HomeDatasource {
  Future<Either<Failure, DashboardModel>> getDashboard();
}
