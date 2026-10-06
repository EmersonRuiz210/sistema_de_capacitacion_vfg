// PUNTO DE ENTRADA DE LA APLICACIÓN
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/api_service.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar token guardado (si existe)
  await ApiService.loadToken();

  runApp(const FinancialEducationApp());
}

class FinancialEducationApp extends StatelessWidget {
  const FinancialEducationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capacitaciones VFG',
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
      // Si hay token → MainScreen, si no → LoginScreen
      home: ApiService.isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}
