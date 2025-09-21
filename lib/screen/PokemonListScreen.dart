// lib/screens/pokemon_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/PokemonSumary.dart';
import '../provider/FavoriteProvider.dart';
import '../service/PokemonService.dart';
import 'FavoriteScreen.dart';
import 'PokemonDetailScreen.dart';


class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final List<PokemonSummary> _pokemons = [];
  bool _isLoading = false;
  bool _hasError = false;
  int _offset = 0;
  final int _limit = 50;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }
//busca novos pokemons, verifica se os pokemons acabaram com hasMore
  Future<void> _fetchPokemons() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final newPokemons = await PokemonService.fetchPokemons(limit: _limit, offset: _offset);
      setState(() {
        _pokemons.addAll(newPokemons);
        _offset += _limit;
        _hasMore = newPokemons.length == _limit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokédex"),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
//chamada dos erros que podem  acontecer  ao chamar a api
      body: _isLoading && _pokemons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _hasError && _pokemons.isEmpty
              ? Center(child: Text("Erro ao carregar Pokémons"))
              : _pokemons.isEmpty
                  ? const Center(child: Text("Nenhum Pokémon encontrado"))
                  : Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 2,
                              //espacamentos horizontais e verticais
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: _pokemons.length,
                            itemBuilder: (context, index) {
                              final pokemon = _pokemons[index];
                              final id = pokemon.id;
                              final name = pokemon.name;
                              final imageUrl = pokemon.imageUrl;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PokemonDetailScreen(pokemonId: id),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        imageUrl,
                                        height: 64,
                                        width: 64,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        name[0].toUpperCase() + name.substring(1),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
//Botao carregar mais pokemons
                        if (_hasMore || _isLoading)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _fetchPokemons,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Carregar Mais'),
                            ),
                          ),
                        if (_hasError && _pokemons.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text('Erro ao carregar mais Pokémons', style: TextStyle(color: Colors.red)),
                          ),
                      ],
                    ),
    );
  }
}
