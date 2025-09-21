// lib/providers/favorite_provider.dart
import 'package:flutter/foundation.dart';

import '../model/PokemonSumary.dart';

class FavoriteProvider extends ChangeNotifier {
  final Map<int, PokemonSummary> _favorites = {};
//dicionario para facilitar busca e remoção e evitar duplicatas
  List<PokemonSummary> get favorites => _favorites.values.toList();

  bool isFavorite(int id) => _favorites.containsKey(id);

  void toggleFavorite(PokemonSummary pokemon) {
    if (isFavorite(pokemon.id)) {
      _favorites.remove(pokemon.id);
    } else {
      _favorites[pokemon.id] = pokemon;
    }
    notifyListeners();
  }

  void removeFavorite(int id) {
    if (_favorites.containsKey(id)) {
      _favorites.remove(id);
      notifyListeners();
    }
  }

  void clear() {
    _favorites.clear();
    notifyListeners();
  }
}
