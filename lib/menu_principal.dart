import 'package:flutter/material.dart';
import 'registro_entrenamiento.dart';
import 'perfil_luchador.dart';
import 'boton_texto.dart';
import 'entrenamiento.dart';
import 'pelea.dart';
import 'calendario.dart';
import 'entrenamiento_repositorio.dart';
import 'pelea_repositorio.dart';
import 'stats_repositorio.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  final EntrenamientoRepositorio _entrenamientoRepositorio =
      EntrenamientoRepositorio();
  final PeleaRepositorio _peleaRepositorio = PeleaRepositorio();
  final StatsRepositorio _statsRepositorio = StatsRepositorio();
  List<Entrenamiento> entrenamientos = [];
  List<Pelea> peleas = [];

  Map<String, double> stats = {
    'Ataque': 0.5,
    'Defensa': 0.5,
    'IQ de pelea': 0.5,
    'Fuerza': 0.5,
    'Agilidad': 0.5,
  };

  final Map<String, List<String>> palabrasClave = {
    'Ataque': [
      'ataque',
      'sumisión',
      'sumision',
      'finalizar',
      'estrangulación',
      'estrangulacion',
      'triángulo',
      'triangulo',
      'kimura',
      'llave',
    ],
    'Defensa': ['defensa', 'guardia', 'escape', 'proteger', 'bloquear'],
    'IQ de pelea': [
      'estrategia',
      'postura',
      'concepto',
      'timing',
      'lectura',
      'plan',
    ],
    'Fuerza': ['fuerza', 'presión', 'presion', 'control', 'peso'],
    'Agilidad': [
      'agilidad',
      'movilidad',
      'transición',
      'transicion',
      'rapidez',
    ],
  };

  @override
  void initState() {
    super.initState();
    cargarEntrenamientos();
    cargarPeleas();
    cargarStats();
  }

  Future<void> cargarEntrenamientos() async {
    final lista = await _entrenamientoRepositorio.cargar();
    setState(() {
      entrenamientos = lista;
    });
  }

  Future<void> guardarEntrenamientosEnDisco() async {
    await _entrenamientoRepositorio.guardar(entrenamientos);
  }

  Future<void> cargarPeleas() async {
    final lista = await _peleaRepositorio.cargar();
    setState(() {
      peleas = lista;
    });
  }

  Future<void> guardarPeleasEnDisco() async {
    await _peleaRepositorio.guardar(peleas);
  }

  Future<void> cargarStats() async {
    final mapa = await _statsRepositorio.cargar();
    if (mapa.isNotEmpty) {
      setState(() {
        stats = mapa;
      });
    }
    // si mapa está vacío, no tocamos "stats": se queda con los
    // valores por defecto ya declarados arriba (Ataque: 0.5, etc.)
  }

  Future<void> guardarStatsEnDisco() async {
    await _statsRepositorio.guardar(stats);
  }

  void actualizarStatsSegunEntrenamiento(Entrenamiento entrenamiento) {
    final texto = '${entrenamiento.tecnica} ${entrenamiento.consejo}'
        .toLowerCase();

    palabrasClave.forEach((stat, palabras) {
      final coincide = palabras.any((palabra) => texto.contains(palabra));
      if (coincide) {
        stats[stat] = (stats[stat]! + 0.04).clamp(0.0, 1.0);
      }
    });
  }

  void guardarEntrenamiento(Entrenamiento entrenamiento) {
    setState(() {
      entrenamientos.add(entrenamiento);
      actualizarStatsSegunEntrenamiento(entrenamiento);
    });
    guardarEntrenamientosEnDisco();
    guardarStatsEnDisco();
  }

  void guardarPelea(Pelea pelea) {
    setState(() {
      peleas.add(pelea);
    });
    guardarPeleasEnDisco();
  }

  Widget botonNavegacion(BuildContext context, String texto, Widget pantalla) {
    return BotonTexto(
      texto: texto,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pantalla),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // AHORA EL FONDO ES EL LOGO EN VEZ DE LA FOTO DEL CINTURON.
          // COMO EL LOGO YA INCLUYE "ROAD TO BLACK" ESCRITO, YA NO
          // HACE FALTA UN Text APARTE ENCIMA
          Image.asset('assets/images/logo_inicio.png', fit: BoxFit.cover),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  botonNavegacion(
                    context,
                    'Nuevo entrenamiento',
                    RegistroEntrenamiento(
                      entrenamientos: entrenamientos,
                      onGuardar: guardarEntrenamiento,
                    ),
                  ),
                  const SizedBox(height: 8),
                  botonNavegacion(
                    context,
                    'Mi perfil',
                    PerfilLuchador(
                      stats: stats,
                      peleas: peleas,
                      onGuardarPelea: guardarPelea,
                    ),
                  ),
                  const SizedBox(height: 8),
                  botonNavegacion(
                    context,
                    'Calendario',
                    CalendarioEntrenamientos(entrenamientos: entrenamientos),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
