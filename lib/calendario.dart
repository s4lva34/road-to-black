import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'entrenamiento.dart';

class CalendarioEntrenamientos extends StatefulWidget {
  final List<Entrenamiento> entrenamientos;

  const CalendarioEntrenamientos({super.key, required this.entrenamientos});

  @override
  State<CalendarioEntrenamientos> createState() =>
      _CalendarioEntrenamientosState();
}

class _CalendarioEntrenamientosState extends State<CalendarioEntrenamientos> {
  DateTime diaFocalizado = DateTime.now();
  DateTime? diaSeleccionado;

  // DEVUELVE LOS ENTRENAMIENTOS QUE OCURRIERON EN UN DIA CONCRETO,
  // COMPARANDO SOLO AÑO/MES/DIA (IGNORANDO LA HORA EXACTA)
  List<Entrenamiento> entrenamientosDelDia(DateTime dia) {
    return widget.entrenamientos.where((e) {
      return e.fecha.year == dia.year &&
          e.fecha.month == dia.month &&
          e.fecha.day == dia.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final entrenamientosSeleccionados = diaSeleccionado != null
        ? entrenamientosDelDia(diaSeleccionado!)
        : <Entrenamiento>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2015),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: diaFocalizado,
            // MARCA COMO "SELECCIONADO" EL DIA QUE EL USUARIO TOCO
            selectedDayPredicate: (dia) =>
                diaSeleccionado != null && isSameDay(dia, diaSeleccionado),
            // eventLoader LE DICE AL CALENDARIO QUE DIAS TIENEN
            // ENTRENAMIENTOS, PARA PINTAR UN PUNTITO DEBAJO
            eventLoader: entrenamientosDelDia,
            onDaySelected: (seleccionado, focalizado) {
              setState(() {
                diaSeleccionado = seleccionado;
                diaFocalizado = focalizado;
              });
            },
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: entrenamientosSeleccionados.isEmpty
                ? Center(
                    child: Text(
                      diaSeleccionado == null
                          ? 'Toca un día para ver los entrenamientos'
                          : 'Sin entrenamientos ese día',
                    ),
                  )
                : ListView.builder(
                    itemCount: entrenamientosSeleccionados.length,
                    itemBuilder: (context, index) {
                      final entrenamiento = entrenamientosSeleccionados[index];
                      return ListTile(
                        title: Text(entrenamiento.tecnica),
                        subtitle: Text(entrenamiento.consejo),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
