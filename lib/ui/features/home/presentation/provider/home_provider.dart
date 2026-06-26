import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/dashboard_model.dart';
import '../../domain/usecase/home_usecase.dart';
import '../../domain/usecase/usecase_impl/home_usecase_impl.dart';

class HomeProvider extends ChangeNotifier {
  final HomeUseCase _useCase;

  HomeProvider(this._useCase);

  bool isLoading = false;
  String? errorMessage;
  DashboardModel? dashboard;
  bool isAvailable = true;

  Future<void> fetchDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _useCase.getDashboard();
    result.fold(
      (f) => errorMessage = f.message,
      (d) => dashboard = d,
    );

    isLoading = false;
    notifyListeners();
  }

  void toggleAvailability() {
    isAvailable = !isAvailable;
    notifyListeners();
  }
}

final homeProvider = ChangeNotifierProvider<HomeProvider>(
  (ref) => HomeProvider(ref.read(homeUseCaseProvider)),
);
