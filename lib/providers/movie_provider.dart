import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_api.dart';

class MovieProvider extends ChangeNotifier {
  bool _loading = false;
  List<MovieModel> _movies = [];

  bool get loading => _loading;
  List<MovieModel> get movies => _movies;

  Future<void> loadMovies({ bool refresh = false }) async {

    if (_movies.isNotEmpty && !refresh) return;

    _loading = true;
    notifyListeners();

    try {
      _movies = await MovieApi.getAllMovies();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}