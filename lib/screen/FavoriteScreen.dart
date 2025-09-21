// lib/screens/favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/FavoriteProvider.dart';
import 'PokemonDetailScreen.dart';



class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = context.watch<FavoriteProvider>();
    final favorites = favProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('Nenhum Pokémon favoritado'))
          : ListView.separated(
        itemCount: favorites.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final p = favorites[index];
          return ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(p.imageUrl)),
            title: Text(p.name.toUpperCase()),
            trailing: IconButton(
              icon: const Icon(Icons.star),
              onPressed: () {
                // desfav
                context.read<FavoriteProvider>().removeFavorite(p.id);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PokemonDetailScreen(pokemonId: p.id, summary: p),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
