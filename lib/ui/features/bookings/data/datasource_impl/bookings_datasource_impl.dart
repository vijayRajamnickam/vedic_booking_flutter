import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/either.dart';
import '../datasource/bookings_datasource.dart';
import '../model/booking_model.dart';

class BookingsDatasourceImpl implements BookingsDatasource {
  final Box<Map> _box;

  BookingsDatasourceImpl(this._box);

  @override
  Future<Either<Failure, List<BookingModel>>> getBookings() async {
    final result = Either<Failure, List<BookingModel>>();
    try {
      // Return cached bookings if available
      if (_box.isNotEmpty) {
        final bookings = _box.values
            .map((e) => BookingModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        result.setRight(bookings);
        return result;
      }
      // Load from mock JSON asset on first run
      final raw = await rootBundle.loadString('assets/json/mock_data.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final list = (json['bookings'] as List)
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList();
      // Persist to Hive
      for (final booking in list) {
        await _box.put(booking.id, booking.toJson());
      }
      result.setRight(list);
    } catch (e) {
      result.setLeft(Failure(message: e.toString()));
    }
    return result;
  }

  @override
  Future<Either<Failure, BookingModel>> getBookingById(String id) async {
    final result = Either<Failure, BookingModel>();
    try {
      final raw = _box.get(id);
      if (raw == null) {
        result.setLeft(Failure(message: 'Booking $id not found'));
      } else {
        result.setRight(
            BookingModel.fromJson(Map<String, dynamic>.from(raw)));
      }
    } catch (e) {
      result.setLeft(Failure(message: e.toString()));
    }
    return result;
  }

  @override
  Future<Either<Failure, void>> updateBookingStatus(
      String id, BookingStatus status) async {
    final result = Either<Failure, void>();
    try {
      final raw = _box.get(id);
      if (raw == null) {
        result.setLeft(Failure(message: 'Booking $id not found'));
        return result;
      }
      final updated = BookingModel.fromJson(Map<String, dynamic>.from(raw))
          .copyWith(status: status);
      await _box.put(id, updated.toJson());
      result.setRight(null);
    } catch (e) {
      result.setLeft(Failure(message: e.toString()));
    }
    return result;
  }
}

// Riverpod provider
final bookingsDatasourceProvider = Provider<BookingsDatasource>((ref) {
  final box = Hive.box<Map>(AppConstants.bookingsBox);
  return BookingsDatasourceImpl(box);
});
