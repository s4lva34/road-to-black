import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'menu_principal.dart';

void main() {
  runApp(const RoadToBlack());
}

class RoadToBlack extends StatelessWidget {
  const RoadToBlack({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.antonTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(primary: Colors.white),

        // NUEVO: EL APPBAR DE TODA LA APP SERA NEGRO CON TEXTO
        // BLANCO POR DEFECTO. YA NO HACE FALTA PONERLO EN CADA PANTALLA
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),

        // NUEVO: TODOS LOS TextButton DE LA APP TENDRAN ESTE ASPECTO
        // POR DEFECTO (BLANCO, SIN TINTE AL PULSAR, CON ANTON).
        // ASI NO HAY QUE REPETIR EL ESTILO EN CADA BOTON
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            overlayColor: Colors.transparent,
            textStyle: GoogleFonts.anton(fontSize: 20, letterSpacing: 1.2),
          ),
        ),

        // NUEVO: TODOS LOS TextField/DropdownButtonFormField DE LA APP
        // TENDRAN ESTE FONDO RELLENO Y BORDES REDONDEADOS POR DEFECTO
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.08),
          hintStyle: const TextStyle(color: Colors.white38),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
      home: const MenuPrincipal(),
    );
  }
}
