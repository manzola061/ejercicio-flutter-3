import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokeApiService {
  final String _urlBase = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> obtenerListaPokemon(int offset, int limite, {String? tipo}) async {
    if (tipo == null) {
      final respuesta = await http.get(Uri.parse('$_urlBase/pokemon?offset=$offset&limit=$limite'));

      if (respuesta.statusCode == 200) {
        final datos = json.decode(respuesta.body);
        List<dynamic> resultados = datos['results'];

        List<Pokemon> pokemones = [];
        for (var resultado in resultados) {
          final detallePokemon = await obtenerPokemonPorNombreOId(resultado['name']);
          pokemones.add(detallePokemon);
        }

        return pokemones;
      } else {
        throw Exception('No se pudo obtener la lista de Pokémon');
      }
    } else {
      return obtenerPokemonesPorTipo(tipo);
    }
  }

  Future<List<String>> obtenerTiposPokemon() async {
    final respuesta = await http.get(Uri.parse('$_urlBase/type'));

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);
      List<dynamic> tipos = datos['results'];
      return tipos.map<String>((tipo) => tipo['name']).toList();
    } else {
      throw Exception('No se pudo obtener la lista de tipos de Pokémon');
    }
  }

  Future<List<Pokemon>> obtenerPokemonesPorTipo(String tipo) async {
    final respuesta = await http.get(Uri.parse('$_urlBase/type/$tipo'));

    if (respuesta.statusCode == 200) {
      final datos = json.decode(respuesta.body);
      List<dynamic> listaPokemon = datos['pokemon'];

      List<Pokemon> pokemones = [];
      for (var entrada in listaPokemon) {
        final detallePokemon = await obtenerPokemonPorNombreOId(entrada['pokemon']['name']);
        pokemones.add(detallePokemon);
      }

      return pokemones;
    } else {
      throw Exception('No se pudieron obtener los Pokémon del tipo $tipo');
    }
  }

  Future<Pokemon> obtenerPokemonPorNombreOId(String consulta) async {
    final respuesta = await http.get(Uri.parse('$_urlBase/pokemon/$consulta'.toLowerCase()));

    if (respuesta.statusCode == 200) {
      return Pokemon.fromJson(json.decode(respuesta.body));
    } else {
      throw Exception('No se encontró el Pokémon');
    }
  }
}