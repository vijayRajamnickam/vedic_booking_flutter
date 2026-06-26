import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/utils/either.dart';
import '../../../data/model/booking_model.dart';
import '../../../data/repository_impl/bookings_repository_impl.dart';
import '../../repository/bookings_repository.dart';
import '../bookings_usecase.dart';

class BookingsUseCaseImpl implements BookingsUseCase {
  final BookingsRepository _repository;

  BookingsUseCaseImpl(this._repository);

  @override
  Future<Either<Failure, List<BookingModel>>> getBookings() =>
      _repository.getBookings();

  @override
  Future<Either<Failure, BookingModel>> getBookingById(String id) =>
      _repository.getBookingById(id);

  @override
  Future<Either<Failure, void>> acceptBooking(String id) =>
      _repository.updateBookingStatus(id, BookingStatus.confirmed);

  @override
  Future<Either<Failure, void>> declineBooking(String id) =>
      _repository.updateBookingStatus(id, BookingStatus.cancelled);

  @override
  Future<Either<Failure, void>> startRitual(String id) =>
      _repository.updateBookingStatus(id, BookingStatus.inProgress);

  @override
  Future<Either<Failure, void>> endRitual(String id) =>
      _repository.updateBookingStatus(id, BookingStatus.completed);
}

final bookingsUseCaseProvider = Provider<BookingsUseCase>((ref) {
  return BookingsUseCaseImpl(ref.read(bookingsRepositoryProvider));
});
