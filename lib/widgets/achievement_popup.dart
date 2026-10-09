// POPUP DE NUEVO LOGRO

import 'package:flutter/material.dart';

class AchievementPopup extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final String? icono;

  const AchievementPopup({
    super.key,
    required this.titulo,
    required this.descripcion,
    this.icono,
  });

  /// Muestra el popup como un diálogo
  static Future<void> show(
    BuildContext context, {
    required String titulo,
    required String descripcion,
    String? icono,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AchievementPopup(
        titulo: titulo,
        descripcion: descripcion,
        icono: icono,
      ),
    );
  }

  /// Muestra múltiples logros en secuencia
  static Future<void> showMultiple(
    BuildContext context,
    List<dynamic> logros,
  ) async {
    for (final logro in logros) {
      if (!context.mounted) break;
      await show(
        context,
        titulo: logro['titulo'] ?? '¡Nuevo logro!',
        descripcion: logro['descripcion'] ?? '',
        icono: logro['icono'],
      );
      // Pequeña pausa entre cada uno
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  IconData _getIcon() {
    final icons = {
      'military_tech': Icons.military_tech,
      'workspace_premium': Icons.workspace_premium,
      'emoji_events': Icons.emoji_events,
      'star': Icons.star,
      'local_fire_department': Icons.local_fire_department,
      'menu_book': Icons.menu_book,
      'crown': Icons.workspace_premium,
    };
    return icons[icono] ?? Icons.emoji_events;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono grande con animación
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Texto
            const Text(
              '🏆 ¡LOGRO DESBLOQUEADO!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              descripcion,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Botón
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange[800],
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '¡Genial!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
