import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void updateUser({ required String name, required String address}) {
    if (_user == null) return;

    _user = UserModel(
      userId: _user!.userId,
      name: name,
      email: _user!.email,
      role: _user!.role,
      address: address,
      isActive: _user!.isActive,
    );
    notifyListeners();
  }
}
