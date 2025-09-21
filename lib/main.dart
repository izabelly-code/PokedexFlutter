// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/provider/FavoriteProvider.dart';
import 'package:untitled/screen/PokemonListScreen.dart';

//Colocando FavoritoProvider como global
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoriteProvider(),
      child: const Pokedex(),
    ),
  );
}

class Pokedex extends StatelessWidget {
  const Pokedex({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokemonListScreen(),
    );
  }
}
