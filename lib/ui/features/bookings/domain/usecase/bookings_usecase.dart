import '../../../../../core/utils/either.dart';
import '../../data/model/booking_model.dart';

abstract class BookingsUseCase {
  Future<Either<Failure, List<BookingModel>>> getBookings();
  Future<Either<Failure, BookingModel>> getBookingById(String id);
  Future<Either<Failure, void>> acceptBooking(String id);
  Future<Either<Failure, void>> declineBooking(String id);
  Future<Either<Failure, void>> startRitual(String id);
  Future<Either<Failure, void>> endRitual(String id);
}
