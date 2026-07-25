import 'package:flutter/material.dart';

// WIDGET COMPARTIDO: UN BOTON DE "SOLO TEXTO", SIN MARCO NI FONDO.
// SE USA TANTO EN EL MENU (PARA NAVEGAR) COMO EN LOS FORMULARIOS
// (PARA ACCIONES COMO "GUARDAR"). EL ESTILO VISUAL (COLOR, FUENTE)
// YA LO HEREDA AUTOMATICAMENTE DEL textButtonTheme DEFINIDO EN
// main.dart, ASI QUE AQUI SOLO HACE FALTA EL TEXTO Y LA ACCION
class BotonTexto extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotonTexto({super.key, required this.texto, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(texto));
  }
}
