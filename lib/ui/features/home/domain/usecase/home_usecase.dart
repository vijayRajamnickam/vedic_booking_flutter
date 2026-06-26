import '../../../../../core/utils/either.dart';
import '../../data/model/dashboard_model.dart';

abstract class HomeUseCase {
  Future<Either<Failure, DashboardModel>> getDashboard();
}
