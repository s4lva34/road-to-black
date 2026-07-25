import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'boton_texto.dart';

class AjustesPerfil extends StatefulWidget {
  final String nombreActual;
  final String apodoActual;
  final String? fotoActual;
  final String? cinturonActual;
  final int? gradosActual;

  const AjustesPerfil({
    super.key,
    required this.nombreActual,
    required this.apodoActual,
    this.fotoActual,
    this.cinturonActual,
    this.gradosActual,
  });

  @override
  State<AjustesPerfil> createState() => _AjustesPerfilState();
}

class _AjustesPerfilState extends State<AjustesPerfil> {
  late final TextEditingController nombreController;
  late final TextEditingController apodoController;

  String? fotoPath;
  String? cinturonSeleccionado;
  int? gradosSeleccionados;

  final List<String> cinturones = [
    'Blanco',
    'Azul',
    'Morado',
    'Marrón',
    'Negro',
  ];
  final List<int> grados = [1, 2, 3, 4];

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.nombreActual);
    apodoController = TextEditingController(text: widget.apodoActual);
    fotoPath = widget.fotoActual;
    cinturonSeleccionado = widget.cinturonActual;
    gradosSeleccionados = widget.gradosActual;
  }

  @override
  void dispose() {
    nombreController.dispose();
    apodoController.dispose();
    super.dispose();
  }

  Future<void> elegirFoto() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        fotoPath = imagen.path;
      });
    }
  }

  void guardarYVolver() {
    Navigator.pop(context, {
      'nombre': nombreController.text,
      'apodo': apodoController.text,
      'foto': fotoPath,
      'cinturon': cinturonSeleccionado,
      'grados': gradosSeleccionados,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: elegirFoto,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white24,
                  backgroundImage: fotoPath != null
                      ? FileImage(File(fotoPath!))
                      : null,
                  child: fotoPath == null
                      ? const Icon(Icons.camera_alt, size: 32)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(hintText: 'Tu nombre'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: apodoController,
              decoration: const InputDecoration(hintText: 'Apodo (opcional)'),
            ),
            const SizedBox(height: 20),

            const Text('Cinturón'),
            DropdownButtonFormField<String>(
              initialValue: cinturonSeleccionado,
              hint: const Text('Selecciona tu cinturón'),
              items: cinturones
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => cinturonSeleccionado = v),
            ),
            const SizedBox(height: 16),
            const Text('Grados'),
            DropdownButtonFormField<int>(
              initialValue: gradosSeleccionados,
              hint: const Text('Selecciona tus grados'),
              items: grados
                  .map((g) => DropdownMenuItem(value: g, child: Text('$g')))
                  .toList(),
              onChanged: (v) => setState(() => gradosSeleccionados = v),
            ),
            const SizedBox(height: 20),

            BotonTexto(texto: 'Guardar', onPressed: guardarYVolver),
          ],
        ),
      ),
    );
  }
}
