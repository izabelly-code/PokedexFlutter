// lib/services/pokemon_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Pokemon.dart';
import '../model/PokemonSumary.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  /// Retorna uma lista de resumos (id, nome, imagem pequena).
  static Future<List<PokemonSummary>> fetchPokemons({int limit = 50, int offset = 0}) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit&offset=$offset'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar lista de Pokémons');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    return results.map((item) {
      final name = item['name'] as String;
      final url = item['url'] as String;
      final id = _extractIdFromUrl(url);
      final imageUrl =
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
      return PokemonSummary(id: id, name: name, imageUrl: imageUrl);
    }).toList();
  }

  /// Detalhes completos do Pokémon (peso, altura, habilidades, imagem oficial).
  static Future<Pokemon> fetchPokemonDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar detalhes do Pokémon');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    return Pokemon.fromJson(data);
  }

  static int _extractIdFromUrl(String url) {
    final match = RegExp(r'\/pokemon\/(\d+)\/').firstMatch(url);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 0;
  }
}
