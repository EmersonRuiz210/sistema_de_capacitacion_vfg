import 'package:flutter/material.dart';

/// Modelo que representa un MÓDULO de capacitación completo
class TrainingModule {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String assetPath;

  TrainingModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.assetPath,
  });

  /// Lista de todos los módulos disponibles en la app
  static List<TrainingModule> getModules() {
    return [
      TrainingModule(
        id: 'financiero',
        title: 'Educación Financiera',
        subtitle: '4 herramientas para tu dinero',
        description: 'Aprende a usar mejor tu dinero y tu préstamo: Ahorro, Crédito, Interés y Presupuesto.',
        icon: Icons.account_balance_wallet,
        color: const Color(0xFF1A5276),
        assetPath: 'financial',
      ),
      TrainingModule(
        id: 'ambiental',
        title: 'Capacitación Ambiental',
        subtitle: 'Cuida el planeta y tu bolsillo',
        description: 'Descubre cómo cuidar el medio ambiente, reducir gastos y contribuir a un mejor futuro.',
        icon: Icons.eco,
        color: const Color(0xFF27AE60),
        assetPath: 'environmental',
      ),
      TrainingModule(
        id: 'empoderamiento',
        title: 'Empoderamiento Bíblico',
        subtitle: 'Visión de Plenitud',
        description: 'Descubre tu identidad, visión, buenas relaciones y diseña tu plan de vida basado en principios bíblicos.',
        icon: Icons.auto_awesome,
        color: const Color(0xFF16A085),
        assetPath: 'empowerment',
      ),
    ];
  }
}
