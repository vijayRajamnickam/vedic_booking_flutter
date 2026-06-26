import '../../../../../core/utils/either.dart';
import '../../data/model/booking_model.dart';

abstract class BookingsRepository {
  Future<Either<Failure, List<BookingModel>>> getBookings();
  Future<Either<Failure, BookingModel>> getBookingById(String id);
  Future<Either<Failure, void>> updateBookingStatus(String id, BookingStatus status);
}
