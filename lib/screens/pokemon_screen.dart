import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../models/pokemon_model.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controladorBusqueda = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<PokemonProvider>(context, listen: false).obtenerTiposPokemon();
    Provider.of<PokemonProvider>(context, listen: false).obtenerPokemones();
  }

  @override
  Widget build(BuildContext context) {
    final proveedor = Provider.of<PokemonProvider>(context);
    final pokemones = proveedor.pokemones;
    final pokemonBuscado = proveedor.pokemonBuscado;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PokeApp',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controladorBusqueda,
                    decoration: InputDecoration(
                      hintText: 'Buscar por ID o Nombre...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    proveedor.buscarPokemon(_controladorBusqueda.text.trim().toLowerCase());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: proveedor.tipoSeleccionado,
              hint: const Text("Filtrar por tipo"),
              items: [
                const DropdownMenuItem(
                  value: "Todos",
                  child: Text("TODOS"),
                ),
                ...proveedor.tipos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo.toUpperCase()),
                  );
                }).toList(),
              ],
              onChanged: (valor) {
                proveedor.establecerTipoSeleccionado(valor == "Todos" ? null : valor);
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: proveedor.cargando
                ? const Center(child: CircularProgressIndicator())
                : pokemonBuscado != null
                    ? _construirTarjetaPokemon(pokemonBuscado)
                    : _construirGrillaPokemon(pokemones),
          ),
          if (pokemonBuscado == null) _construirBotonesPaginacion(proveedor),
        ],
      ),
    );
  }

  Widget _construirGrillaPokemon(List<Pokemon> pokemones) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: pokemones.length,
      itemBuilder: (context, indice) {
        return _construirTarjetaPokemon(pokemones[indice]);
      },
    );
  }

  Widget _construirTarjetaPokemon(Pokemon pokemon) {
    return GestureDetector(
      onTap: () => _mostrarDetallePokemon(context, pokemon),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        color: pokemon.getColor().withAlpha(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              pokemon.imagenUrl,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              pokemon.nombre.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("ID: ${pokemon.id}"),
            Text("Tipo: ${pokemon.tipos.join(', ')}"),
          ],
        ),
      ),
    );
  }

  void _mostrarDetallePokemon(BuildContext context, Pokemon pokemon) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: pokemon.getColor(),
              width: 3,
            ),
          ),
          title: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: pokemon.getColor(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              pokemon.nombre.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pokemon.getColor().withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    pokemon.imagenUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow("ID", pokemon.id.toString()),
                _buildDetailRow("Tipos", pokemon.tipos.join(', ')),
                _buildDetailRow("Altura", "${pokemon.altura / 10} m"),
                _buildDetailRow("Peso", "${pokemon.peso / 10} kg"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: pokemon.getColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

// ... (resto del archivo igual)

  Widget _construirBotonesPaginacion(PokemonProvider proveedor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: proveedor.paginaActual > 0 ? proveedor.paginaAnterior : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text("Anterior"),
          ),
          ElevatedButton(
            onPressed: proveedor.siguientePagina,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text("Siguiente"),
          ),
        ],
      ),
    );
  }
}