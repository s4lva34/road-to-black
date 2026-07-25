class Entrenamiento {
  final String tecnica;
  final String consejo;
  final DateTime fecha;

  Entrenamiento({
    required this.tecnica,
    required this.consejo,
    required this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      'tecnica': tecnica,
      'consejo': consejo,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Entrenamiento.fromJson(Map<String, dynamic> json) {
    return Entrenamiento(
      tecnica: json['tecnica'],
      consejo: json['consejo'],
      fecha: json['fecha'] != null
          ? DateTime.parse(json['fecha'])
          : DateTime.now(),
    );
  }
}
