import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/profile_model.dart';
import '../../domain/usecase/profile_usecase.dart';
import '../../domain/usecase/usecase_impl/profile_usecase_impl.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileUseCase _useCase;
  ProfileProvider(this._useCase);

  bool isLoading = false;
  String? errorMessage;
  ProfileModel? profile;

  Future<void> fetchProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final result = await _useCase.getProfile();
    result.fold(
      (f) => errorMessage = f.message,
      (p) => profile = p,
    );

    isLoading = false;
    notifyListeners();
  }
}

final profileProvider = ChangeNotifierProvider<ProfileProvider>(
  (ref) => ProfileProvider(ref.read(profileUseCaseProvider)),
);
