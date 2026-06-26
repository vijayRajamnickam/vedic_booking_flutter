import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/earnings_model.dart';
import '../../domain/usecase/earnings_usecase.dart';
import '../../domain/usecase/usecase_impl/earnings_usecase_impl.dart';

class EarningsProvider extends ChangeNotifier {
  final EarningsUseCase _useCase;
  EarningsProvider(this._useCase);

  bool isLoading = false;
  String? errorMessage;
  EarningsModel? earnings;

  Future<void> fetchEarnings() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _useCase.getEarnings();
    result.fold(
      (f) => errorMessage = f.message,
      (e) => earnings = e,
    );

    isLoading = false;
    notifyListeners();
  }
}

final earningsProvider = ChangeNotifierProvider<EarningsProvider>(
  (ref) => EarningsProvider(ref.read(earningsUseCaseProvider)),
);
