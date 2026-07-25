import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'entrenamiento.dart';

// Esta clase es la ÚNICA responsable de leer y escribir
// entrenamientos en el almacenamiento del dispositivo.
// Si mañana cambiamos shared_preferences por otra cosa,
// solo tocamos ESTE archivo.
class EntrenamientoRepositorio {
  Future<List<Entrenamiento>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getStringList('entrenamientos');

    if (guardado == null) return [];

    return guardado
        .map((texto) => Entrenamiento.fromJson(jsonDecode(texto)))
        .toList();
  }

  Future<void> guardar(List<Entrenamiento> entrenamientos) async {
    final prefs = await SharedPreferences.getInstance();
    final listaTexto = entrenamientos
        .map((entrenamiento) => jsonEncode(entrenamiento.toJson()))
        .toList();
    await prefs.setStringList('entrenamientos', listaTexto);
  }
}
