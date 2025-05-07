import 'package:flutter/material.dart';
import 'package:tick/models/admin.dart';

class AdminSession extends ChangeNotifier {
  Admin? _admin;

  Admin? get admin => _admin;

  void login(Admin admin) {
    _admin = admin;
    notifyListeners();
  }

  void logout() {
    _admin = null;
    notifyListeners();
  }
}
