import 'package:flutter/material.dart';

import '../utils/colors.dart';

/// Modelo que representa un tema de capacitación ambiental
/// Contiene la información del PDF "Capacitación Ambiental para Clientes"
class EnvironmentalTopic {
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

  EnvironmentalTopic({
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

  /// Retorna la lista de todos los temas ambientales
  static List<EnvironmentalTopic> getTopics() {
    return [
      EnvironmentalTopic(
        id: 'medio_ambiente',
        title: 'El Medio Ambiente',
        subtitle: 'Todo lo que nos rodea',
        description:
            'Es todo lo que nos rodea dentro de nuestro planeta tierra.',
        keyPoints: ['Suelo', 'Agua', 'Aire', 'Flora', 'Fauna', 'Clima'],
        example: 'Cuando respiramos aire puro, bebemos agua limpia o vemos árboles verdes, estamos disfrutando del medio ambiente.',
        advice: 'Cuida cada elemento natural como si fuera tuyo.',
        question: '¿Qué elemento del medio ambiente valoras más?',
        icon: Icons.public,
        color: AppColors.environmentColor,
      ),
      EnvironmentalTopic(
        id: 'cambio_climatico',
        title: 'Cambio Climático',
        subtitle: 'Efectos y consecuencias',
        description: 'Los cambios en el clima afectan nuestras vidas: sequías, inundaciones, calor intenso y enfermedades.',
        keyPoints: [
          'Lluvias más potentes',
          'Falta de lluvias y sequías',
          'Calor intenso',
          'Escasez de alimentos',
          'Contaminación del aire',
          'Enfermedades respiratorias',
        ],
        example: 'En Guatemala, las sequías prolongadas han afectado las cosechas de maíz y frijol en el corredor seco.',
        advice: 'Pequeñas acciones diarias reducen el cambio climático.',
        question: '¿Has notado cambios en el clima de tu comunidad?',
        icon: Icons.thermostat,
        color: AppColors.climateColor,
      ),
      EnvironmentalTopic(
        id: 'causas',
        title: 'Causas del Cambio',
        subtitle: 'Por qué tenemos cambios en el clima',
        description: 'Nuestras acciones diarias están provocando cambios en el clima que nos afectan a todos.',
        keyPoints: [
          'Uso de plástico inadecuado',
          'Falta de reciclaje como el plástico y el vidrio',
          'Deforestación: talar árboles sin resembrar',
          'Mal uso del agua',
        ],
        example: 'Cuando tiramos basura al río, contaminamos el agua y dañamos el ecosistema.',
        advice: 'Evita el plástico de un solo uso siempre que puedas.',
        question: '¿Cuál de estas causas ves en tu comunidad?',
        icon: Icons.warning_amber,
        color: AppColors.warningOrange,
      ),
      EnvironmentalTopic(
        id: 'como_cuidar',
        title: 'Cómo Cuidar el Ambiente',
        subtitle: 'Acciones que puedes hacer hoy',
        description: 'Existen muchas acciones sencillas que puedes implementar desde tu hogar para cuidar el planeta.',
        keyPoints: [
          'Recicla papel, latas y vidrio',
          'Evita los plásticos',
          'Usa el papel de forma responsable',
          'Usa bolsas reutilizables',
          'Utiliza el agua adecuadamente',
          'Usa bombillas ahorrativas',
          'Apaga los focos en el día',
          'Planta árboles',
        ],
        example: 'Reciclar una tonelada de papel salva 17 árboles y ahorra 26,000 litros de agua.',
        advice: 'Elige 3 acciones y conviértelas en hábitos.',
        question: '¿Cuál de estas acciones ya haces?',
        icon: Icons.recycling,
        color: AppColors.recyclingColor,
      ),
      EnvironmentalTopic(
        id: 'beneficios',
        title: 'Beneficios',
        subtitle: 'Gana tú y gana el planeta',
        description: 'Al disminuir el uso de recursos, contribuyes al medio ambiente y también reduces gastos económicos para tu hogar.',
        keyPoints: [
          'Planeta más limpio para tus hijos',
          'Menos contaminación',
          'Reduces gastos económicos',
          'Ahorro de energía',
          'Ahorro de agua',
          'Comunidad más saludable',
        ],
        example: 'Doña Carmen cambió los focos de su casa por bombillas LED. Su factura de luz bajó de Q150 a Q90 al mes.',
        advice: 'Cuidar el ambiente también cuida tu bolsillo.',
        question: '¿Cuánto podrías ahorrar cuidando el ambiente?',
        icon: Icons.thumb_up,
        color: AppColors.successGreen,
      ),
      EnvironmentalTopic(
        id: 'reto_familiar',
        title: 'Reto en Familia',
        subtitle: 'VisionFund Guatemala y tú hacen la diferencia',
        description: 'Toma una fotografía con tu familia en donde estés ayudando al medio ambiente y participa por un premio sorpresa.',
        keyPoints: [
          'Toma una foto con tu familia',
          'Realiza una acción por el ambiente',
          'Envía la foto al WhatsApp 5842-8209',
          'Escribe tu nombre completo',
          'Incluye una frase que describa tu foto',
          'El ganador se anuncia a fin de mes',
        ],
        example: 'La familia López plantó 3 árboles en su patio y envió la foto al reto. Ganaron el premio sorpresa del mes.',
        advice: 'La foto más creativa se lleva el premio.',
        question: '¿Qué acción ambiental harías con tu familia?',
        icon: Icons.emoji_events,
        color: AppColors.warningOrange,
      ),
    ];
  }
}
