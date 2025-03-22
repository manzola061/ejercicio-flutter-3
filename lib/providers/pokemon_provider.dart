import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';
import '../services/pokeapi_service.dart';

class PokemonProvider with ChangeNotifier {
  final List<Pokemon> _pokemones = [];
  final PokeApiService _servicioPokeApi = PokeApiService();
  final List<String> _tipos = [];
  bool _cargando = false;
  int _paginaActual = 0;
  final int _limite = 50;
  String? _tipoSeleccionado;
  Pokemon? _pokemonBuscado;

  List<Pokemon> get pokemones => _pokemones;
  List<String> get tipos => _tipos;
  bool get cargando => _cargando;
  int get paginaActual => _paginaActual;
  String? get tipoSeleccionado => _tipoSeleccionado;
  Pokemon? get pokemonBuscado => _pokemonBuscado;

  Future<void> obtenerTiposPokemon() async {
    _tipos.clear();
    _tipos.addAll(await _servicioPokeApi.obtenerTiposPokemon());
    notifyListeners();
  }

  Future<void> obtenerPokemones() async {
    if (_cargando) return;
    _cargando = true;
    notifyListeners();

    int offset = _paginaActual * _limite;
    List<Pokemon> nuevosPokemones = await _servicioPokeApi.obtenerListaPokemon(offset, _limite, tipo: _tipoSeleccionado);

    _pokemones.clear();
    _pokemones.addAll(nuevosPokemones);

    _cargando = false;
    notifyListeners();
  }

  void siguientePagina() {
    _paginaActual++;
    obtenerPokemones();
  }

  void paginaAnterior() {
    if (_paginaActual > 0) {
      _paginaActual--;
      obtenerPokemones();
    }
  }

  void establecerTipoSeleccionado(String? tipo) {
    _tipoSeleccionado = tipo;
    obtenerPokemones();
    notifyListeners();
  }

  Future<void> buscarPokemon(String consulta) async {
    _cargando = true;
    _pokemonBuscado = null;
    notifyListeners();

    try {
      final pokemon = await _servicioPokeApi.obtenerPokemonPorNombreOId(consulta);
      _pokemonBuscado = pokemon;
    } catch (e) {
      _pokemonBuscado = null;
    }

    _cargando = false;
    notifyListeners();
  }

  void limpiarBusqueda() {
    _pokemonBuscado = null;
    notifyListeners();
  }
}