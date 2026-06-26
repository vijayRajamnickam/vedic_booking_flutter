import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/booking_model.dart';
import '../../domain/usecase/bookings_usecase.dart';
import '../../domain/usecase/usecase_impl/bookings_usecase_impl.dart';

class BookingsProvider extends ChangeNotifier {
  final BookingsUseCase _useCase;

  BookingsProvider(this._useCase);

  // --- state ---
  bool isLoading = false;
  String? errorMessage;
  List<BookingModel> _allBookings = [];
  BookingStatus? _activeFilter;
  String _searchQuery = '';

  // --- getters ---
  List<BookingModel> get bookings {
    var result = List<BookingModel>.from(_allBookings);
    if (_activeFilter != null) {
      result = result.where((b) => b.status == _activeFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((b) => b.customerName.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  BookingStatus? get activeFilter => _activeFilter;
  String get searchQuery => _searchQuery;

  int get totalCount => _allBookings.length;
  int get pendingCount =>
      _allBookings.where((b) => b.status == BookingStatus.pending).length;
  int get completedCount =>
      _allBookings.where((b) => b.status == BookingStatus.completed).length;
  int get cancelledCount =>
      _allBookings.where((b) => b.status == BookingStatus.cancelled).length;

  // --- actions ---
  Future<void> fetchBookings() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _useCase.getBookings();
    result.fold(
      (failure) => errorMessage = failure.message,
      (list) => _allBookings = list,
    );

    isLoading = false;
    notifyListeners();
  }

  void setFilter(BookingStatus? status) {
    _activeFilter = status;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<bool> acceptBooking(String id) async {
    final result = await _useCase.acceptBooking(id);
    if (result.isRight()) {
      _updateLocal(id, BookingStatus.confirmed);
      return true;
    }
    return false;
  }

  Future<bool> declineBooking(String id) async {
    final result = await _useCase.declineBooking(id);
    if (result.isRight()) {
      _updateLocal(id, BookingStatus.cancelled);
      return true;
    }
    return false;
  }

  Future<bool> startRitual(String id) async {
    final result = await _useCase.startRitual(id);
    if (result.isRight()) {
      _updateLocal(id, BookingStatus.inProgress);
      return true;
    }
    return false;
  }

  Future<bool> endRitual(String id) async {
    final result = await _useCase.endRitual(id);
    if (result.isRight()) {
      _updateLocal(id, BookingStatus.completed);
      return true;
    }
    return false;
  }

  BookingModel? getBookingById(String id) {
    try {
      return _allBookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  void _updateLocal(String id, BookingStatus status) {
    final idx = _allBookings.indexWhere((b) => b.id == id);
    if (idx != -1) {
      _allBookings[idx] = _allBookings[idx].copyWith(status: status);
      notifyListeners();
    }
  }
}

final bookingsProvider = ChangeNotifierProvider<BookingsProvider>((ref) {
  return BookingsProvider(ref.read(bookingsUseCaseProvider));
});
