import 'package:flutter/material.dart';

import '../utils/colors.dart';

/// Modelo que representa un tema de Empoderamiento Bíblico
/// Basado en la "Guía para Facilitadores - Visión de Plenitud"
class EmpowermentTopic {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> keyPoints;
  final String example;
  final String advice;
  final String question;
  final String bibleVerse; // Versículo bíblico del tema
  final String verseReference; // Referencia del versículo
  final IconData icon;
  final Color color;

  EmpowermentTopic({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.keyPoints,
    required this.example,
    required this.advice,
    required this.question,
    required this.bibleVerse,
    required this.verseReference,
    required this.icon,
    required this.color,
  });

  /// Retorna la lista de todos los temas de empoderamiento
  static List<EmpowermentTopic> getTopics() {
    return [
      EmpowermentTopic(
        id: 'identidad',
        title: 'Identidad',
        subtitle: '¿Quién soy en Dios?',
        description: 'Tu valor no está en el dinero, sino en lo que Dios puso en ti. Fuiste creado a imagen y semejanza de Dios.',
        keyPoints: [
          'Fuiste creado a imagen de Dios',
          'Tienes dignidad y un gran valor',
          'Estás coronado de gloria y honor',
          'Tu identidad no es de escasez, sino de propósito',
        ],
        example: 'Doña Rosa se sentía "solo una agricultora pobre". Cuando descubrió su identidad en Dios, levantó la cabeza y comenzó a soñar en grande.',
        advice: 'Recuerda cada día quién eres: hijo o hija del Rey.',
        question: '¿Quién eres o quién dicen que eres?',
        bibleVerse: 'Cuando Dios creó al hombre, lo creó a su imagen; varón y mujer los creó.',
        verseReference: 'Génesis 1:27 (DHH)',
        icon: Icons.person_outline,
        color: AppColors.identityColor,
      ),
      EmpowermentTopic(
        id: 'vision',
        title: 'Visión',
        subtitle: 'Un mapa para tu futuro',
        description: 'Una visión clara nos ayuda a vivir con propósito, enfocándonos en lo que realmente importa. Dios quiere darnos vida plena y abundante.',
        keyPoints: [
          'Tu visión es el mapa hacia tus sueños',
          'Piensa en 3 años: ¿cómo te imaginas?',
          'Alinea tu visión con la vida plena de Jesús',
          'Aprovecha los dones que Dios te dio',
        ],
        example: 'Doña Rosa tenía una visión clara: comprar una deshidratadora solar. Esa visión la llevó a unir fuerzas con tres vecinas.',
        advice: 'Escribe tu visión y revísala cada semana.',
        question: '¿Tienes actualmente una visión de tu vida?',
        bibleVerse: 'Mi propósito es darles una vida plena y abundante.',
        verseReference: 'Juan 10:10 (NTV)',
        icon: Icons.visibility,
        color: AppColors.visionColor,
      ),
      EmpowermentTopic(
        id: 'relaciones',
        title: 'Relaciones',
        subtitle: 'Empatía y Compasión',
        description: 'Construyamos puentes, no muros. La empatía nos ayuda a entender a otros; la compasión nos impulsa a actuar para mejorar su situación.',
        keyPoints: [
          'Derriba los muros del prejuicio',
          'Empatía: "Entiendo tu preocupación"',
          'Compasión: "Voy a ayudarte a lograrlo"',
          'Jesús rompía barreras con amor',
          'La unidad nos hace imparables',
        ],
        example: 'Rosa unió a María (pesca), Juana (transporte) y Carmen (números). Aunque sus familias tenían pleitos, construyeron un puente de empatía y compasión.',
        advice:
            'Antes de juzgar, pregúntate: ¿qué está sintiendo esta persona?',
        question: '¿Cómo puedo poner en práctica la empatía y la compasión?',
        bibleVerse: 'Si supieras lo que Dios puede dar, y quién es el que te está pidiendo agua, tú le habrías pedido a él, y él te habría dado agua que da vida.',
        verseReference: 'Juan 4:7-10 (DHH)',
        icon: Icons.favorite,
        color: AppColors.relationshipsColor,
      ),
      EmpowermentTopic(
        id: 'plan_de_vida',
        title: 'Mi Plan de Vida',
        subtitle: 'El mapa personal hacia el éxito',
        description: 'Un plan de vida es tu mapa personal para alcanzar el éxito tanto en tu negocio como en tu vida personal. Ayuda a balancear el tiempo, invertir bien y tomar decisiones.',
        keyPoints: [
          'Balancea el tiempo entre negocio y familia',
          'Invierte de manera correcta tus recursos',
          'Sirve como guía para decisiones difíciles',
          'Permite medir el progreso más allá de lo económico',
          'Áreas: Negocio, Finanzas, Capacitación, Salud, Familia',
        ],
        example: 'Marta Eliza Gómez definió metas a 3 años: duplicar ventas de su taller, tener ahorros para sus hijos, capacitarse como experta y crear un grupo de mujeres emprendedoras.',
        advice: 'Revisa tu plan de vida cada 3 meses y ajusta lo necesario.',
        question: '¿Cuáles son tus metas a 3 años en cada área de tu vida?',
        bibleVerse: 'El hombre hace planes, pero el Señor dirige sus pasos.',
        verseReference: 'Proverbios 16:9',
        icon: Icons.assignment,
        color: AppColors.planColor,
      ),
      EmpowermentTopic(
        id: 'plenitud',
        title: 'Visión de Plenitud',
        subtitle: 'Transformando vidas',
        description: 'Un programa internacional para acompañar a clientes y sus familias en su proceso de empoderamiento basado en principios bíblicos, integrando la fe y la fortaleza en cada etapa.',
        keyPoints: [
          'Acompaña a clientes y familias',
          'Basado en principios bíblicos',
          'Integra fe y fortaleza',
          'Descubre lo que Dios tiene preparado',
          'No es un programa religioso, es de crecimiento',
        ],
        example: 'Cuatro mujeres de Escuintla pasaron de estar solas y con dudas a ser dueñas de su futuro. Descubrieron que: "Una mujer es fuerte, pero juntas, son imparables."',
        advice: 'Comparte lo que aprendes con tu familia y comunidad.',
        question: '¿Estás listo para descubrir lo que Dios tiene para ti?',
        bibleVerse: 'Yo he venido para que tengan vida, y para que la tengan en abundancia.',
        verseReference: 'Juan 10:10',
        icon: Icons.auto_awesome,
        color: AppColors.plenitudColor,
      ),
      EmpowermentTopic(
        id: 'compromisos',
        title: 'Mis Compromisos',
        subtitle: 'Pasando a la acción',
        description: 'Es momento de comprometerte con tu crecimiento. Escribe compromisos concretos en tres áreas clave de tu vida.',
        keyPoints: [
          'Compromiso con mi negocio',
          'Compromiso con mi familia',
          'Compromiso conmigo misma',
          'Escribe metas específicas y medibles',
          'Comparte tus compromisos con alguien de confianza',
        ],
        example: 'Doña Rosa se comprometió con su negocio (comprar la deshidratadora), con su familia (mejor vida para sus hijos) y consigo misma (creer en su valor).',
        advice: 'Un compromiso escrito es un compromiso cumplido.',
        question: '¿Cuáles son tus 3 compromisos más importantes hoy?',
        bibleVerse: 'Todo lo puedo en Cristo que me fortalece.',
        verseReference: 'Filipenses 4:13',
        icon: Icons.handshake,
        color: AppColors.empowermentModuleColor,
      ),
    ];
  }
}
