import 'package:flutter/material.dart';

/// Paleta de colores principal de la aplicación
/// Centraliza todos los colores para mantener consistencia visual
class AppColors {
  // Colores principales
  static const Color primaryBlue = Color(0xFF1A5276);
  static const Color secondaryBlue = Color(0xFF2E86C1);
  static const Color lightBlue = Color(0xFFD6EAF8);

  // Colores para estados
  static const Color successGreen = Color(0xFF27AE60);
  static const Color warningOrange = Color(0xFFF39C12);
  static const Color dangerRed = Color(0xFFE74C3C);

  // Colores neutros
  static const Color darkGray = Color(0xFF2C3E50);
  static const Color mediumGray = Color(0xFF7F8C8D);
  static const Color lightGray = Color(0xFFF5F6FA);

  // Colores específicos para cada tema financiero
  static const Color savingsColor = Color(0xFF2ECC71); // Verde - Ahorro
  static const Color creditColor = Color(0xFF3498DB); // Azul - Crédito
  static const Color interestColor = Color(0xFFE67E22); // Naranja - Interés
  static const Color budgetColor = Color(0xFF9B59B6); // Morado - Presupuesto

  // ==================== COLORES DEL MÓDULO AMBIENTAL ====================
  // Colores específicos para cada tema ambiental
  static const Color environmentColor = Color(0xFF27AE60); // Verde principal
  static const Color recyclingColor = Color(
    0xFF16A085,
  ); // Verde azulado - Reciclaje
  static const Color waterColor = Color(0xFF3498DB); // Azul - Agua
  static const Color energyColor = Color(0xFFF39C12); // Naranja - Energía
  static const Color climateColor = Color(0xFFE67E22); // Naranja oscuro - Clima

  // Colores de los módulos (para el menú principal)
  static const Color financialModuleColor = Color(
    0xFF1A5276,
  ); // Azul financiero
  static const Color environmentalModuleColor = Color(
    0xFF27AE60,
  ); // Verde ambiental
  // ==================== COLORES DEL MÓDULO EMPODERAMIENTO ====================
  // Basados en el atardecer del PDF (teal, naranja, dorado)
  static const Color identityColor = Color(0xFF8E44AD); // Morado - Identidad
  static const Color visionColor = Color(0xFFE67E22); // Naranja - Visión
  static const Color relationshipsColor = Color(
    0xFFE74C3C,
  ); // Rojo coral - Relaciones
  static const Color planColor = Color(0xFF16A085); // Verde teal - Plan de vida
  static const Color plenitudColor = Color(0xFF1ABC9C); // Teal principal

  // Color del módulo para el menú principal
  static const Color empowermentModuleColor = Color(0xFF16A085);
}
