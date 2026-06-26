import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/either.dart';
import '../datasource/home_datasource.dart';
import '../model/dashboard_model.dart';

class HomeDatasourceImpl implements HomeDatasource {
  @override
  Future<Either<Failure, DashboardModel>> getDashboard() async {
    final result = Either<Failure, DashboardModel>();
    try {
      final raw = await rootBundle.loadString('assets/json/mock_data.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      result.setRight(DashboardModel.fromJson(
          json['dashboard'] as Map<String, dynamic>));
    } catch (e) {
      result.setLeft(Failure(message: e.toString()));
    }
    return result;
  }
}

final homeDatasourceProvider = Provider<HomeDatasource>(
  (_) => HomeDatasourceImpl(),
);
