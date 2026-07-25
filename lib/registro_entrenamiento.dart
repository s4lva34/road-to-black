import 'package:flutter/material.dart';
import 'entrenamiento.dart';
import 'boton_texto.dart';

class RegistroEntrenamiento extends StatefulWidget {
  final List<Entrenamiento> entrenamientos;
  final void Function(Entrenamiento) onGuardar;

  const RegistroEntrenamiento({
    super.key,
    required this.entrenamientos,
    required this.onGuardar,
  });

  @override
  State<RegistroEntrenamiento> createState() => _RegistroEntrenamientoState();
}

class _RegistroEntrenamientoState extends State<RegistroEntrenamiento> {
  final TextEditingController tecnicaController = TextEditingController();
  final TextEditingController consejoController = TextEditingController();

  @override
  void dispose() {
    tecnicaController.dispose();
    consejoController.dispose();
    super.dispose();
  }

  void guardarEntrenamiento() {
    final nuevo = Entrenamiento(
      tecnica: tecnicaController.text,
      consejo: consejoController.text,
      fecha: DateTime.now(),
    );
    widget.onGuardar(nuevo);
    setState(() {
      tecnicaController.clear();
      consejoController.clear();
    });
  }

  Widget campoTexto(
    String etiqueta,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiqueta),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo entrenamiento')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            campoTexto(
              '¿Qué has trabajado hoy?',
              tecnicaController,
              'Ej: Guardia cerrada, triángulo...',
            ),
            const SizedBox(height: 20),
            campoTexto(
              'Consejo del profesor',
              consejoController,
              'Ej: Controlar más la postura...',
            ),
            const SizedBox(height: 20),
            BotonTexto(texto: 'Guardar', onPressed: guardarEntrenamiento),
            const SizedBox(height: 20),
            const Text('Historial:'),
            Expanded(
              child: ListView.builder(
                itemCount: widget.entrenamientos.length,
                itemBuilder: (context, index) {
                  final entrenamiento = widget.entrenamientos[index];
                  return ListTile(
                    title: Text(entrenamiento.tecnica),
                    subtitle: Text(entrenamiento.consejo),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
