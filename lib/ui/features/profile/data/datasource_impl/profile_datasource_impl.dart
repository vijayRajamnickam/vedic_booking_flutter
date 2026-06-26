import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/utils/either.dart';
import '../datasource/profile_datasource.dart';
import '../model/profile_model.dart';

class ProfileDatasourceImpl implements ProfileDatasource {
  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    final result = Either<Failure, ProfileModel>();
    try {
      final raw = await rootBundle.loadString('assets/json/mock_data.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      result.setRight(
          ProfileModel.fromJson(json['pandit'] as Map<String, dynamic>));
    } catch (e) {
      result.setLeft(Failure(message: e.toString()));
    }
    return result;
  }
}

final profileDatasourceProvider = Provider<ProfileDatasource>(
  (_) => ProfileDatasourceImpl(),
);
