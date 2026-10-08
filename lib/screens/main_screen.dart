// PANTALLA PRINCIPAL - Lista de cursos desde API

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'topic_list_screen.dart';
import 'login_screen.dart';
import 'progress_screen.dart';
import '../models/financial.dart';
import '../models/ambiental.dart';
import '../models/empoderamiento.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<dynamic> courses = [];
  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Carga los cursos y los datos del usuario
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Cargar cursos desde el backend
      final data = await ApiService.getCourses();

      // Cargar datos del usuario (guardados en login)
      final user = await ApiService.getUserData();

      if (!mounted) return;
      setState(() {
        courses = data;
        userData = user;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  /// Cierra sesión y regresa al login
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await ApiService.logout();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capacitaciones VFG'),
        actions: [
          //Botón para ver "Mi Progreso"
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Mi Progreso',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProgressScreen()),
              ).then((_) {
                // Al volver, recargar datos por si hubo cambios
                _loadData();
              });
            },
          ),
          // Botón de cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F6FA), Colors.white],
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // Cargando
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando cursos...'),
          ],
        ),
      );
    }

    // Error
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Error al cargar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A5276),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Contenido
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saludo al usuario
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Bienvenido${userData != null ? ', ${userData!['nombres']}' : ''}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A5276),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Elige el módulo de capacitación que quieres aprender',
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Lista de cursos
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return _buildCourseCard(courses[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Construye la tarjeta de un curso
  Widget _buildCourseCard(dynamic course) {
    // Mapeo visual por ID de curso
    final courseId = course['id_curso'];
    final colorMap = {
      1: const Color(0xFF1A5276), // Financiero - azul
      2: const Color(0xFF27AE60), // Ambiental - verde
      3: const Color(0xFF16A085), // Empoderamiento - teal
    };
    final iconMap = {
      1: Icons.account_balance_wallet,
      2: Icons.eco,
      3: Icons.auto_awesome,
    };

    final color = colorMap[courseId] ?? const Color(0xFF1A5276);
    final icon = iconMap[courseId] ?? Icons.school;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => _openCourse(course),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.05),
                color.withValues(alpha: 0.15),
              ],
            ),
          ),
          child: Row(
            children: [
              // Icono del curso
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 44),
              ),
              const SizedBox(width: 16),

              // Info del curso
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['titulo'] ?? 'Sin título',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course['descripcion'] ?? '',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Comenzar',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                        Icon(Icons.arrow_forward, size: 16, color: color),
                        const Spacer(),
                        // Contador de módulos
                        if (course['total_modulos'] != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${course['total_modulos']} temas',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Abre el curso seleccionado
  void _openCourse(dynamic course) {
    // Cargar temas según el ID del curso
    List<dynamic> topics;
    Color courseColor;

    switch (course['id_curso']) {
      case 1:
        topics = FinancialTopic.getTopics();
        courseColor = const Color(0xFF1A5276);
        break;
      case 2:
        topics = EnvironmentalTopic.getTopics();
        courseColor = const Color(0xFF27AE60);
        break;
      case 3:
        topics = EmpowermentTopic.getTopics();
        courseColor = const Color(0xFF16A085);
        break;
      default:
        topics = [];
        courseColor = const Color(0xFF1A5276);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TopicListScreen(
          moduleTitle: course['titulo'] ?? 'Curso',
          moduleColor: courseColor,
          topics: topics,
          courseId: course['id_curso'],
        ),
      ),
    );
  }
}
