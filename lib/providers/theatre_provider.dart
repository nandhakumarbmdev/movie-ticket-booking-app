import 'package:flutter/material.dart';
import '../models/theatre_model.dart';
import '../services/theatre_api.dart';

class TheatreProvider extends ChangeNotifier {
  bool _loading = false;
  List<TheatreModel> _theatres = [];

  bool get loading => _loading;
  List<TheatreModel> get theatres => _theatres;

  Future<void> loadTheatres({bool refresh = false}) async {
    if (_theatres.isNotEmpty && !refresh) return;

    _loading = true;
    notifyListeners();

    try {
      _theatres = await TheatreService.getAllTheatres();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}