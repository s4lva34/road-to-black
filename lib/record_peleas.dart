import 'package:flutter/material.dart';
import 'pelea.dart';
import 'boton_texto.dart';

class RecordPeleas extends StatefulWidget {
  final List<Pelea> peleas;
  final void Function(Pelea) onGuardar;

  const RecordPeleas({
    super.key,
    required this.peleas,
    required this.onGuardar,
  });

  @override
  State<RecordPeleas> createState() => _RecordPeleasState();
}

class _RecordPeleasState extends State<RecordPeleas> {
  final TextEditingController rivalController = TextEditingController();
  bool victoriaSeleccionada = true;
  DateTime fechaSeleccionada = DateTime.now();

  @override
  void dispose() {
    rivalController.dispose();
    super.dispose();
  }

  // ABRE EL CALENDARIO NATIVO Y ESPERA A QUE EL USUARIO ELIJA UN DIA
  Future<void> elegirFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() {
        fechaSeleccionada = fecha;
      });
    }
  }

  void guardarPelea() {
    widget.onGuardar(
      Pelea(
        rival: rivalController.text,
        victoria: victoriaSeleccionada,
        fecha: fechaSeleccionada,
      ),
    );
    setState(() {
      rivalController.clear();
      victoriaSeleccionada = true;
      fechaSeleccionada = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    // CALCULAMOS VICTORIAS Y DERROTAS CONTANDO CUANTAS PELEAS
    // DE LA LISTA CUMPLEN CADA CONDICION
    final victorias = widget.peleas.where((p) => p.victoria).length;
    final derrotas = widget.peleas.where((p) => !p.victoria).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Récord de peleas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // RESUMEN DE VICTORIAS/DERROTAS ARRIBA DEL TODO
            Text(
              '$victorias V - $derrotas D',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: rivalController,
              decoration: const InputDecoration(hintText: 'Nombre del rival'),
            ),
            const SizedBox(height: 12),

            // DOS BOTONES PARA ELEGIR VICTORIA O DERROTA, UNO AL LADO
            // DEL OTRO. EL SELECCIONADO SE RESALTA CON MAS OPACIDAD
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => victoriaSeleccionada = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: victoriaSeleccionada
                            ? Colors.green.withValues(alpha: 0.3)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Victoria',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => victoriaSeleccionada = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !victoriaSeleccionada
                            ? Colors.red.withValues(alpha: 0.3)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Derrota', textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // AL PULSAR, ABRE EL CALENDARIO. MUESTRA LA FECHA
            // YA ELEGIDA COMO TEXTO
            GestureDetector(
              onTap: elegirFecha,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}',
                ),
              ),
            ),
            const SizedBox(height: 20),

            BotonTexto(texto: 'Guardar pelea', onPressed: guardarPelea),
            const SizedBox(height: 20),

            const Text('Historial:'),
            Expanded(
              child: ListView.builder(
                itemCount: widget.peleas.length,
                itemBuilder: (context, index) {
                  final pelea = widget.peleas[index];
                  return ListTile(
                    title: Text(pelea.rival),
                    subtitle: Text(
                      '${pelea.fecha.day}/${pelea.fecha.month}/${pelea.fecha.year}',
                    ),
                    trailing: Text(
                      pelea.victoria ? 'Victoria' : 'Derrota',
                      style: TextStyle(
                        color: pelea.victoria ? Colors.green : Colors.red,
                      ),
                    ),
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
