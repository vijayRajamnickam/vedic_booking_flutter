import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/either.dart';
import '../datasource/earnings_datasource.dart';
import '../model/earnings_model.dart';

class EarningsDatasourceImpl implements EarningsDatasource {
  @override
  Future<Either<Failure, EarningsModel>> getEarnings() async {
    final result = Either<Failure, EarningsModel>();
    try {
      final raw = await rootBundle.loadString('assets/json/mock_data.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      result.setRight(EarningsModel.fromJson(
          json['earnings'] as Map<String, dynamic>));
    } catch (e) {
      result.setLeft(Failure(message: e.toString()));
    }
    return result;
  }
}

final earningsDatasourceProvider = Provider<EarningsDatasource>(
  (_) => EarningsDatasourceImpl(),
);
