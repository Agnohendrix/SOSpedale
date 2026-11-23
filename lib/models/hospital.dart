class Hospital {
  final String nome;
  final double lat;
  final double lon;

  Hospital({
    required this.nome,
    required this.lat,
    required this.lon,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      nome: json['nome'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
    );
  }
}