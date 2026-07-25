class Pelea {
  final String rival;
  final bool victoria;
  final DateTime fecha;

  Pelea({required this.rival, required this.victoria, required this.fecha});

  Map<String, dynamic> toJson() {
    return {
      'rival': rival,
      'victoria': victoria,
      // toIso8601String() CONVIERTE LA FECHA A UN TEXTO ESTANDAR
      // (EJ: "2026-07-20T00:00:00.000"), QUE SE PUEDE GUARDAR
      // Y RECONSTRUIR SIN AMBIGUEDAD
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Pelea.fromJson(Map<String, dynamic> json) {
    return Pelea(
      rival: json['rival'],
      victoria: json['victoria'],
      // DateTime.parse HACE EL CAMINO INVERSO: DE ESE TEXTO
      // ESTANDAR, VUELVE A CONSTRUIR UN DateTime REAL
      fecha: DateTime.parse(json['fecha']),
    );
  }
}
