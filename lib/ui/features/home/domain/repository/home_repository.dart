import '../../../../../core/utils/either.dart';
import '../../data/model/dashboard_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, DashboardModel>> getDashboard();
}
