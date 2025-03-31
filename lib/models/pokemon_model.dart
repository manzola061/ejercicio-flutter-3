import 'package:flutter/material.dart';

class Pokemon {
  final String nombre;
  final String imagenUrl;
  final int id;
  final List<String> tipos;
  final int altura;
  final int peso;

  Pokemon({
    required this.nombre,
    required this.imagenUrl,
    required this.id,
    required this.tipos,
    required this.altura,
    required this.peso,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      nombre: json['name'],
      imagenUrl: json['sprites']['front_default'] ?? '',
      id: json['id'],
      tipos: (json['types'] as List).map((tipo) => tipo['type']['name'] as String).toList(),
      altura: json['height'],
      peso: json['weight'],
    );
  }

  Color getColor() {
    if (tipos.isEmpty) return Colors.grey;
    
    final tipoPrimario = tipos.first;
    switch (tipoPrimario) {
      case 'normal':
        return const Color(0xFFA8A878);
      case 'fire':
        return const Color(0xFFF08030);
      case 'water':
        return const Color(0xFF6890F0);
      case 'electric':
        return const Color(0xFFF8D030);
      case 'grass':
        return const Color(0xFF78C850);
      case 'ice':
        return const Color(0xFF98D8D8);
      case 'fighting':
        return const Color(0xFFC03028);
      case 'poison':
        return const Color(0xFFA040A0);
      case 'ground':
        return const Color(0xFFE0C068);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'psychic':
        return const Color(0xFFF85888);
      case 'bug':
        return const Color(0xFFA8B820);
      case 'rock':
        return const Color(0xFFB8A038);
      case 'ghost':
        return const Color(0xFF705898);
      case 'dragon':
        return const Color(0xFF7038F8);
      case 'dark':
        return const Color(0xFF705848);
      case 'steel':
        return const Color(0xFFB8B8D0);
      case 'fairy':
        return const Color(0xFFEE99AC);
      default:
        return Colors.grey;
    }
  }
}