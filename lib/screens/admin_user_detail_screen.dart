// DETALLE DE USUARIO (Vista Admin)
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/report_service.dart';
import 'ai_report_screen.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final int userId;
  final String userName;

  const AdminUserDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<AdminUserDetailScreen> createState() => _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  Map<String, dynamic>? detail;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getAdminUserDetail(widget.userId);
      if (!mounted) return;
      setState(() {
        detail = data;
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
        title: Text(widget.userName),
        foregroundColor: Colors.orange[800],
        actions: [
          //Botón de Informe IA
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Generar Informe con IA',
            color: Colors.purple,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AiReportScreen(
                    userId: widget.userId,
                    userName: widget.userName,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'PDF del usuario',
            onPressed: () => ReportService.generateUserPDFReport(
              context,
              widget.userId,
              widget.userName,
            ),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadDetail),
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadDetail,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final user = detail!['user'] ?? {};
    final progreso = detail!['progreso'] as List<dynamic>? ?? [];
    final intentos = detail!['intentos'] as List<dynamic>? ?? [];
    final logros = detail!['logros'] as List<dynamic>? ?? [];
    final stats = detail!['estadisticas'] ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info del usuario
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange.withValues(alpha: 0.15),
                    child: Text(
                      _getInitial(user['nombres']),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _formatUserName(user['nombres'], user['apellidos']),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatString(user['email']),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(
                      _formatString(user['nombre_rol']).toUpperCase(),
                    ),
                    backgroundColor: Colors.orange.withValues(alpha: 0.15),
                    labelStyle: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Estadísticas
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  _formatNumber(stats['total_intentos']),
                  'Intentos',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  _formatNumber(stats['promedio_puntaje']),
                  'Promedio',
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  _formatNumber(stats['mejor_puntaje']),
                  'Mejor',
                  Colors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progreso por curso
          const Text(
            'Progreso por curso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (progreso.isEmpty)
            _buildEmpty('Sin progreso registrado')
          else
            ...progreso.map((p) => _buildProgressCard(p)),
          const SizedBox(height: 20),

          // Logros
          Text(
            'Logros obtenidos (${logros.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (logros.isEmpty)
            _buildEmpty('Sin logros obtenidos')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: logros.map((l) => _buildAchievementChip(l)).toList(),
            ),
          const SizedBox(height: 20),

          // Intentos
          Text(
            'Historial de intentos (${intentos.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (intentos.isEmpty)
            _buildEmpty('Sin intentos')
          else
            ...intentos.map((i) => _buildAttemptCard(i)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ============ HELPERS DE FORMATO ============

  /// Obtiene la inicial del nombre para el avatar
  String _getInitial(dynamic nombres) {
    if (nombres == null) return '?';
    final str = nombres.toString();
    return str.isEmpty ? '?' : str[0].toUpperCase();
  }

  /// Formatea el nombre completo del usuario
  String _formatUserName(dynamic nombres, dynamic apellidos) {
    final n = nombres?.toString() ?? '';
    final a = apellidos?.toString() ?? '';
    return '$n $a'.trim();
  }

  /// Convierte cualquier valor a String de forma segura
  String _formatString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// Formatea números de forma segura (evita el error int/String)
  String _formatNumber(dynamic value) {
    if (value == null) return '0';
    if (value is int) return value.toString();
    if (value is double) return value.toStringAsFixed(0);
    if (value is num) return value.toInt().toString();
    return value.toString();
  }

  // ============ WIDGETS ============

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildProgressCard(dynamic p) {
    final progreso = (p['promedio_progreso'] as num?)?.toDouble() ?? 0;
    final colorMap = {
      1: const Color(0xFF1A5276),
      2: const Color(0xFF27AE60),
      3: const Color(0xFF16A085),
    };
    final color = colorMap[p['id_curso']] ?? Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _formatString(p['curso_titulo']),
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                Text(
                  '${progreso.round()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progreso / 100,
                minHeight: 6,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${p['modulos_completados']} de ${p['total_modulos']} módulos',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementChip(dynamic logro) {
    return Chip(
      avatar: const Icon(Icons.emoji_events, color: Colors.amber, size: 18),
      label: Text(_formatString(logro['titulo'])),
      backgroundColor: Colors.amber.withValues(alpha: 0.15),
    );
  }

  Widget _buildAttemptCard(dynamic intento) {
    final puntaje = (intento['puntaje_obtenido'] as num?)?.toDouble() ?? 0;
    final puntajeMax = (intento['puntaje_maximo'] as num?)?.toDouble() ?? 100;
    final porcentaje = puntajeMax > 0
        ? (puntaje / puntajeMax * 100).round()
        : 0;

    Color statusColor;
    if (porcentaje >= 80) {
      statusColor = Colors.green;
    } else if (porcentaje >= 60) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            porcentaje >= 80 ? Icons.emoji_events : Icons.quiz,
            color: statusColor,
          ),
        ),
        title: Text(_formatString(intento['evaluacion_titulo'])),
        subtitle: Text(
          '${_formatString(intento['curso_titulo'])} • Intento #${intento['intento_numero']}',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: Text(
          '$porcentaje%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: statusColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(message, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
}
