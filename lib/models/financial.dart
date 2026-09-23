import 'package:flutter/material.dart';

import '../utils/colors.dart';

/// Modelo que representa un tema de educación financiera
/// Contiene toda la información de cada tema (ahorro, crédito, etc.)
class FinancialTopic {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> keyPoints;
  final String example;
  final String advice;
  final String question;
  final IconData icon;
  final Color color;

  FinancialTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.keyPoints,
    required this.example,
    required this.advice,
    required this.question,
    required this.icon,
    required this.color,
  });

  /// Retorna la lista de todos los temas financieros
  static List<FinancialTopic> getTopics() {
    return [
      FinancialTopic(
        id: 'ahorro',
        title: 'Ahorro',
        subtitle: 'Guarda para tu futuro',
        description: 'Guardar una parte de lo que recibes para emergencias o metas. No importa la cantidad, importa la constancia.',
        keyPoints: [
          'Q1 al día son Q30 al mes',
          'Ahorra primero, gasta después',
          'No esperes a que te sobre',
        ],
        example: 'Doña Rosa ahorró Q5 diarios, en 6 meses juntó Q900 y compró una olla más grande para su negocio de atol. Ahora gana más.',
        advice: 'Comienza con pequeñas cantidades y sé constante.',
        question: '¿Cuánto podrías ahorrar al día?',
        icon: Icons.savings,
        color: AppColors.savingsColor,
      ),
      FinancialTopic(
        id: 'credito',
        title: 'Crédito',
        subtitle: 'Usa el dinero inteligentemente',
        description: 'Dinero que recibes hoy y devuelves en cuotas con un pequeño costo (interés).',
        keyPoints: [
          'Úsalo para invertir en tu negocio',
          'No pidas más de lo que puedes pagar',
          'Paga a tiempo para tener buen récord',
        ],
        example: 'Esperanza pidió préstamo para su siembra, pero su familia la presionó para comprar televisor y moto. Pidió más préstamos y no pudo pagar.',
        advice: 'Evalúa siempre si el préstamo te generará ingresos.',
        question: '¿Para qué usarías un préstamo?',
        icon: Icons.credit_card,
        color: AppColors.creditColor,
      ),
      FinancialTopic(
        id: 'interes',
        title: 'Interés',
        subtitle: 'Conoce el costo del dinero',
        description: 'Es el costo que pagas por usar dinero prestado. También puede ser lo que ganas cuando prestas tu dinero.',
        keyPoints: [
          'Interés simple vs compuesto',
          'A mayor plazo, más intereses',
          'Compara tasas antes de pedir',
        ],
        example: 'Pedro pagó Q100 de interés por un préstamo de Q1,000 en 6 meses. Eso es el 10% de interés.',
        advice: 'Siempre pregunta la tasa de interés total.',
        question: '¿Sabes cuánto pagarías en intereses?',
        icon: Icons.trending_up,
        color: AppColors.interestColor,
      ),
      FinancialTopic(
        id: 'presupuesto',
        title: 'Presupuesto',
        subtitle: 'Controla tus ingresos y gastos',
        description: 'Planifica cómo vas a usar tu dinero cada mes. Saber cuánto entra y cuánto sale es clave.',
        keyPoints: [
          'Registra todos tus ingresos',
          'Anota todos tus gastos',
          'Diferencia gastos necesarios de innecesarios',
        ],
        example: 'María anotó todos sus gastos por una semana. Descubrió que gastaba Q50 diarios en comida. Ajustó su presupuesto y ahorró Q200 a la semana.',
        advice: 'Lleva un registro diario de tus gastos por un mes.',
        question: '¿Llevas un control de tus gastos?',
        icon: Icons.account_balance_wallet,
        color: AppColors.budgetColor,
      ),
    ];
  }
}
