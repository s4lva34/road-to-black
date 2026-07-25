import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Esta clase es la ÚNICA responsable de leer y escribir
// las stats del luchador en el almacenamiento del dispositivo.
// No conoce los valores por defecto (eso es decisión de MenuPrincipal):
// si no hay nada guardado, devuelve un Map vacío.
class StatsRepositorio {
  Future<Map<String, double>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getString('stats');

    if (guardado == null) return {};

    final mapa = jsonDecode(guardado) as Map<String, dynamic>;
    return mapa.map((clave, valor) => MapEntry(clave, valor.toDouble()));
  }

  Future<void> guardar(Map<String, double> stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('stats', jsonEncode(stats));
  }
}
