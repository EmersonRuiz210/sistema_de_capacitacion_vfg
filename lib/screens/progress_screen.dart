// PANTALLA MI PROGRESO
// Muestra estadísticas, progreso por curso y últimos intentos realizados

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/colors.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, dynamic>? summary;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  /// Carga el resumen desde el backend
  Future<void> _loadProgress() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getProgressSummary();
      if (!mounted) return;
      setState(() {
        summary = data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Progreso'),
        foregroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProgress,
            tooltip: 'Actualizar',
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
            Text('Cargando tu progreso...'),
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
                onPressed: _loadProgress,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Contenido
    final cursos = (summary!['cursos'] as List<dynamic>?) ?? [];
    final stats = (summary!['estadisticas'] as Map<String, dynamic>?) ?? {};
    final ultimosIntentos =
        (summary!['ultimos_intentos'] as List<dynamic>?) ?? [];

    return RefreshIndicator(
      onRefresh: _loadProgress,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ESTADÍSTICAS GENERALES
            const Text(
              'Estadísticas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5276),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.assignment_turned_in,
                    value: '${stats['total_intentos'] ?? 0}',
                    label: 'Intentos',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.school,
                    value: '${stats['evaluaciones_realizadas'] ?? 0}',
                    label: 'Evaluaciones',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up,
                    value: _formatNumber(stats['promedio_puntaje']),
                    label: 'Promedio',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.emoji_events,
                    value: _formatNumber(stats['mejor_puntaje']),
                    label: 'Mejor puntaje',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // PROGRESO POR CURSO
            const Text(
              'Progreso por curso',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5276),
              ),
            ),
            const SizedBox(height: 12),
            if (cursos.isEmpty)
              _buildEmptyState('No hay cursos disponibles')
            else
              ...cursos.map((curso) => _buildCourseProgressCard(curso)),
            const SizedBox(height: 32),

            // ÚLTIMOS INTENTOS
            const Text(
              'Últimos intentos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5276),
              ),
            ),
            const SizedBox(height: 12),
            if (ultimosIntentos.isEmpty)
              _buildEmptyState('Aún no has realizado ningún quiz')
            else
              ...ultimosIntentos.map((intento) => _buildAttemptCard(intento)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Formatea un número para mostrar (2 decimales)
  String _formatNumber(dynamic value) {
    if (value == null) return '0.0';
    final num = double.tryParse(value.toString()) ?? 0.0;
    return num.toStringAsFixed(1);
  }

  /// Widget vacío reutilizable
  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Tarjeta de estadística
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  /// Tarjeta de progreso por curso
  Widget _buildCourseProgressCard(dynamic curso) {
    final colorMap = {
      1: const Color(0xFF1A5276),
      2: const Color(0xFF27AE60),
      3: const Color(0xFF16A085),
    };
    final iconMap = {
      1: Icons.account_balance_wallet,
      2: Icons.eco,
      3: Icons.auto_awesome,
    };

    final idCurso = curso['id_curso'];
    final color = colorMap[idCurso] ?? AppColors.primaryBlue;
    final icon = iconMap[idCurso] ?? Icons.school;

    // Calcular porcentaje
    final promedio =
        double.tryParse(curso['promedio_progreso']?.toString() ?? '0') ?? 0;
    final porcentaje = promedio.round();
    final progreso = (promedio / 100).clamp(0.0, 1.0);

    final modulosCompletados = curso['modulos_completados'] ?? 0;
    final totalModulos = curso['total_modulos'] ?? 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    curso['curso_titulo'] ?? 'Curso',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Text(
                  '$porcentaje%',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Barra de progreso
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progreso,
                minHeight: 8,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '$modulosCompletados de $totalModulos módulos completados',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Tarjeta de un intento del historial
  Widget _buildAttemptCard(dynamic intento) {
    final puntaje =
        double.tryParse(intento['puntaje_obtenido']?.toString() ?? '0') ?? 0;
    final puntajeMaximo =
        double.tryParse(intento['puntaje_maximo']?.toString() ?? '100') ?? 100;
    final porcentaje = puntajeMaximo > 0
        ? (puntaje / puntajeMaximo * 100).round()
        : 0;

    // Determinar color según el porcentaje
    Color statusColor;
    IconData statusIcon;
    if (porcentaje >= 80) {
      statusColor = Colors.green;
      statusIcon = Icons.emoji_events;
    } else if (porcentaje >= 60) {
      statusColor = Colors.orange;
      statusIcon = Icons.thumb_up;
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.refresh;
    }

    // Formatear fecha
    String fechaStr = '';
    try {
      final fecha = DateTime.parse(intento['fecha_intento'].toString());
      fechaStr =
          '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      fechaStr = 'Fecha desconocida';
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(statusIcon, color: statusColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    intento['curso_titulo'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    intento['evaluacion_titulo'] ?? '',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  Text(
                    fechaStr,
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${puntaje.toStringAsFixed(1)}/${puntajeMaximo.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                Text(
                  '$porcentaje%',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
