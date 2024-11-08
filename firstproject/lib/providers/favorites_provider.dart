import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<String> _favoriteCities = [];

  List<String> get favoriteCities => _favoriteCities;

  void addFavoriteCity(String city) {
    if (!_favoriteCities.contains(city)) {
      _favoriteCities.add(city);
      notifyListeners();
    }
  }
}
