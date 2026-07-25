import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ajustes_perfil.dart';
import 'record_peleas.dart';
import 'pelea.dart';

class PerfilLuchador extends StatefulWidget {
  final Map<String, double> stats;
  final List<Pelea> peleas;
  final void Function(Pelea) onGuardarPelea;

  const PerfilLuchador({
    super.key,
    required this.stats,
    required this.peleas,
    required this.onGuardarPelea,
  });

  @override
  State<PerfilLuchador> createState() => _PerfilLuchadorState();
}

class _PerfilLuchadorState extends State<PerfilLuchador> {
  String nombre = '';
  String apodo = '';
  String? fotoPath;
  String? cinturonSeleccionado;
  int? gradosSeleccionados;

  @override
  void initState() {
    super.initState();
    cargarDatosPerfil();
  }

  Future<void> cargarDatosPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('nombre') ?? '';
      apodo = prefs.getString('apodo') ?? '';
      fotoPath = prefs.getString('fotoPath');
      cinturonSeleccionado = prefs.getString('cinturon');
      gradosSeleccionados = prefs.getInt('grados');
    });
  }

  Future<void> guardarDatosPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', nombre);
    await prefs.setString('apodo', apodo);
    if (fotoPath != null) await prefs.setString('fotoPath', fotoPath!);
    if (cinturonSeleccionado != null) {
      await prefs.setString('cinturon', cinturonSeleccionado!);
    }
    if (gradosSeleccionados != null) {
      await prefs.setInt('grados', gradosSeleccionados!);
    }
  }

  Future<void> abrirAjustes(BuildContext context) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AjustesPerfil(
          nombreActual: nombre,
          apodoActual: apodo,
          fotoActual: fotoPath,
          cinturonActual: cinturonSeleccionado,
          gradosActual: gradosSeleccionados,
        ),
      ),
    );

    if (resultado != null) {
      setState(() {
        nombre = resultado['nombre'];
        apodo = resultado['apodo'];
        fotoPath = resultado['foto'];
        cinturonSeleccionado = resultado['cinturon'];
        gradosSeleccionados = resultado['grados'];
      });
      guardarDatosPerfil();
    }
  }

  void abrirRecordPeleas(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordPeleas(
          peleas: widget.peleas,
          onGuardar: widget.onGuardarPelea,
        ),
      ),
    );
  }

  Color colorSegunCinturon() {
    switch (cinturonSeleccionado) {
      case 'Blanco':
        return Colors.white;
      case 'Azul':
        return Colors.blue;
      case 'Morado':
        return Colors.purple;
      case 'Marrón':
        return Colors.brown;
      case 'Negro':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // TRADUCE EL CINTURON A UN COLOR DE FONDO PARA LA FRANJA DEL EXTREMO
  // (NORMALMENTE NEGRA, PERO ROJA PARA EL CINTURON NEGRO, PARA QUE
  // SE VEA SOBRE EL FONDO OSCURO DE LA APP)
  Color colorFranja() {
    return cinturonSeleccionado == 'Negro' ? Colors.red : Colors.black;
  }

  Color colorMarcas() => Colors.white;

  // DIBUJA EL CINTURON: UNA BARRA CON EL COLOR PRINCIPAL, Y AL FINAL
  // UNA FRANJA CON TANTAS MARCAS COMO GRADOS TENGAS
  Widget cinturonVisual() {
    final grados = gradosSeleccionados ?? 0;

    return Center(
      child: Container(
        width: 260,
        height: 34,
        decoration: BoxDecoration(
          // BORDE FINO ALREDEDOR DE TODO EL CINTURON, PARA QUE SE
          // DISTINGA DEL FONDO NEGRO DE LA APP (SOBRE TODO LA PARTE
          // DE LA FRANJA, QUE SI NO SE FUNDE CON EL FONDO)
          border: Border.all(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        // ClipRRect RECORTA LO DE DENTRO PARA QUE RESPETE LAS ESQUINAS
        // REDONDEADAS DEL BORDE, EN VEZ DE SALIRSE POR LOS BORDES
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Row(
            children: [
              // LA PARTE PRINCIPAL DEL CINTURON, CON SU COLOR
              Expanded(child: Container(color: colorSegunCinturon())),
              // LA FRANJA DEL EXTREMO, CON LAS MARCAS DE GRADO
              Container(
                width: 90,
                color: colorFranja(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(grados, (index) {
                    return Container(
                      width: 6,
                      height: 20,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: colorMarcas(),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statBar(String nombre, double valor) {
    final color = colorSegunCinturon();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(nombre),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: valor,
              minHeight: 14,
              backgroundColor: color.withValues(alpha: 0.2),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final victorias = widget.peleas.where((p) => p.victoria).length;
    final derrotas = widget.peleas.where((p) => !p.victoria).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => abrirAjustes(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                backgroundImage: fotoPath != null
                    ? FileImage(File(fotoPath!))
                    : null,
                child: fotoPath == null
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                nombre.isEmpty ? 'Sin nombre' : nombre,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            if (apodo.isNotEmpty) Center(child: Text('"$apodo"')),
            const SizedBox(height: 16),

            if (cinturonSeleccionado != null) cinturonVisual(),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () => abrirRecordPeleas(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$victorias V - $derrotas D  ›',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Stats', style: TextStyle(fontSize: 20)),
            statBar('Ataque', widget.stats['Ataque']!),
            statBar('Defensa', widget.stats['Defensa']!),
            statBar('IQ de pelea', widget.stats['IQ de pelea']!),
            statBar('Fuerza', widget.stats['Fuerza']!),
            statBar('Agilidad', widget.stats['Agilidad']!),
          ],
        ),
      ),
    );
  }
}
