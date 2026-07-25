import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'pelea.dart';

// Esta clase es la ÚNICA responsable de leer y escribir
// peleas en el almacenamiento del dispositivo.
// Si mañana cambiamos shared_preferences por otra cosa,
// solo tocamos ESTE archivo.
class PeleaRepositorio {
  Future<List<Pelea>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getStringList('peleas');

    if (guardado == null) return [];

    return guardado.map((texto) => Pelea.fromJson(jsonDecode(texto))).toList();
  }

  Future<void> guardar(List<Pelea> peleas) async {
    final prefs = await SharedPreferences.getInstance();
    final listaTexto = peleas
        .map((pelea) => jsonEncode(pelea.toJson()))
        .toList();
    await prefs.setStringList('peleas', listaTexto);
  }
}
