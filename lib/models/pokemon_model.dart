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
}