// lib/screens/pokemon_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Pokemon.dart';
import '../model/PokemonSumary.dart';
import '../provider/FavoriteProvider.dart';
import '../service/PokemonService.dart';


class PokemonDetailScreen extends StatelessWidget {
  final int pokemonId;
  final PokemonSummary? summary;

  const PokemonDetailScreen({
    super.key,
    required this.pokemonId,
    this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pokémon'),
        actions: [
          // Usamos Consumer/ watch dentro do FutureBuilder mais abaixo para exibir a estrela
        ],
      ),
      body: FutureBuilder<Pokemon>(
        future: PokemonService.fetchPokemonDetail(pokemonId),
        builder: (context, snapshot) {
          final favProvider = context.watch<FavoriteProvider>();

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se summary foi passada, mostramos ela enquanto carrega
            if (summary != null) {
              return _buildLoadingWithSummary(context, summary!, favProvider);
            }
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Não encontrado'));
          }

          final pokemon = snapshot.data!;
          final isFav = favProvider.isFavorite(pokemon.id);
          final pokemonSummary = PokemonSummary(
            id: pokemon.id,
            name: pokemon.name,
            imageUrl: pokemon.imageUrl,
          );

          //Criando a tela apos carregar os dados da api
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // botão de favoritar no topo
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.star : Icons.star_border,
                      size: 32,
                    ),
                    onPressed: () {
                      context.read<FavoriteProvider>().toggleFavorite(pokemonSummary);
                      final snack = isFav ? 'Removido dos favoritos' : 'Adicionado aos favoritos';
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
                    },
                  ),
                ),
                Image.network(
                  pokemon.imageUrl,
                  height: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  pokemon.name.toUpperCase(),
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tipo: ' + pokemon.types.map((t) => t[0].toUpperCase() + t.substring(1)).join(', '),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text('Altura: ${pokemon.height / 10} m'),
                Text('Peso: ${pokemon.weight / 10} kg'),
                const SizedBox(height: 20),
                const Text(
                  'Habilidades',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children: pokemon.abilities
                      .map((a) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('- $a', style: const TextStyle(fontSize: 16)),
                  ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  //tela com resumo enquanto carrega os detalhes
  Widget _buildLoadingWithSummary(BuildContext context, PokemonSummary summary, FavoriteProvider favProvider) {
    final isFav = favProvider.isFavorite(summary.id);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(isFav ? Icons.star : Icons.star_border, size: 32),
              onPressed: () => favProvider.toggleFavorite(summary),
            ),
          ),
          Image.network(summary.imageUrl, height: 220, fit: BoxFit.contain),
          const SizedBox(height: 16),
          Text(summary.name.toUpperCase(), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
