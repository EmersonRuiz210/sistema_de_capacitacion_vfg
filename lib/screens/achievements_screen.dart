// PANTALLA DE LOGROS

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/colors.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<dynamic> logros = [];
  Map<String, dynamic> resumen = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await ApiService.getAllAchievements();
      if (!mounted) return;
      setState(() {
        logros = data['logros'] ?? [];
        resumen = data['resumen'] ?? {};
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

  /// Convierte nombre de ícono a IconData
  IconData _getIcon(String? iconName) {
    final icons = {
      'military_tech': Icons.military_tech,
      'workspace_premium': Icons.workspace_premium,
      'emoji_events': Icons.emoji_events,
      'star': Icons.star,
      'local_fire_department': Icons.local_fire_department,
      'menu_book': Icons.menu_book,
      'crown': Icons.workspace_premium,
      'thumb_up': Icons.thumb_up,
    };
    return icons[iconName] ?? Icons.emoji_events;
  }

  /// Convierte string de color a Color
  Color _getColor(String? colorHex) {
    if (colorHex == null) return AppColors.primaryBlue;
    try {
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Logros'),
        foregroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAchievements,
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
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando tus logros...'),
          ],
        ),
      );
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
              Text('Error: $errorMessage', textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadAchievements,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAchievements,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // RESUMEN
            _buildSummaryCard(),

            const SizedBox(height: 24),

            //LOGROS
            const Text(
              'Todos los logros',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5276),
              ),
            ),
            const SizedBox(height: 12),

            // Grid de logros
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: logros.length,
              itemBuilder: (context, index) {
                return _buildAchievementCard(logros[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Tarjeta de resumen
  Widget _buildSummaryCard() {
    final obtenidos = resumen['obtenidos'] ?? 0;
    final total = resumen['total'] ?? 8;
    final puntos = resumen['puntos'] ?? 0;
    final progreso = total > 0 ? obtenidos / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progreso de logros',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      '$obtenidos de $total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Icon(Icons.stars, color: Colors.amber, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    '$puntos pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progreso * 100).round()}% completado',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Tarjeta de un logro individual
  Widget _buildAchievementCard(dynamic logro) {
    final obtenido = logro['obtenido'] == true;
    final color = _getColor(logro['color']);
    final icon = _getIcon(logro['icono']);

    return Container(
      decoration: BoxDecoration(
        color: obtenido ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: obtenido ? color.withValues(alpha: 0.3) : Colors.grey[300]!,
          width: obtenido ? 2 : 1,
        ),
        boxShadow: obtenido
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: obtenido
                    ? color.withValues(alpha: 0.15)
                    : Colors.grey[300]!,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: obtenido ? color : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 12),

            // Título
            Text(
              logro['titulo'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: obtenido ? color : Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Descripción
            Text(
              logro['descripcion'] ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: obtenido ? Colors.grey[700] : Colors.grey[500],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Estado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: obtenido
                    ? color.withValues(alpha: 0.15)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    obtenido ? Icons.check_circle : Icons.lock,
                    size: 12,
                    color: obtenido ? color : Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    obtenido ? '¡Obtenido!' : 'Bloqueado',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: obtenido ? color : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
