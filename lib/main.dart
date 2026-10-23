import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/admin_dashboard_screen.dart'; // Importamos el panel de admin
import 'services/api_service.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      // ✅ USAMOS UN WIDGET QUE DECIDE LA PANTALLA INICIAL
      home: const InitialRouter(),
    );
  }
}

/// Widget que decide a dónde ir al abrir la app
class InitialRouter extends StatefulWidget {
  const InitialRouter({super.key});

  @override
  State<InitialRouter> createState() => _InitialRouterState();
}

class _InitialRouterState extends State<InitialRouter> {
  bool _loading = true;
  Widget _initialScreen = const LoginScreen();

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    if (!ApiService.isLoggedIn) {
      // No hay sesión -> Login
      setState(() {
        _initialScreen = const LoginScreen();
        _loading = false;
      });
      return;
    }

    // Hay sesión, verificar rol
    final user = await ApiService.getUserData();
    final rol = user?['rol'] ?? user?['nombre_rol'] ?? '';

    setState(() {
      if (rol == 'admin' || rol == 'asesor') {
        _initialScreen = const AdminDashboardScreen();
      } else {
        _initialScreen = const MainScreen();
      }
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _initialScreen;
  }
}
