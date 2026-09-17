import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/main_screens.dart';
import 'utils/colors.dart';

/// Punto de entrada principal de la aplicación
void main() {
  runApp(const FinancialEducationApp());
}

/// Widget raíz de la aplicación de Capacitaciones VFG
class FinancialEducationApp extends StatelessWidget {
  const FinancialEducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Capacitación',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          brightness: Brightness.light,
        ),
        fontFamily: GoogleFonts.inter().fontFamily,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryBlue,
        ),
      ),
      // Pantalla inicial: menú de módulos
      home: const MainScreen(),
    );
  }
}
