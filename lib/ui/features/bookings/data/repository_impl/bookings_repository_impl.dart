import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/either.dart';
import '../../domain/repository/bookings_repository.dart';
import '../datasource/bookings_datasource.dart';
import '../datasource_impl/bookings_datasource_impl.dart';
import '../model/booking_model.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  final BookingsDatasource _datasource;

  BookingsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<BookingModel>>> getBookings() =>
      _datasource.getBookings();

  @override
  Future<Either<Failure, BookingModel>> getBookingById(String id) =>
      _datasource.getBookingById(id);

  @override
  Future<Either<Failure, void>> updateBookingStatus(
          String id, BookingStatus status) =>
      _datasource.updateBookingStatus(id, status);
}

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return BookingsRepositoryImpl(ref.read(bookingsDatasourceProvider));
});
