import 'package:flutter/material.dart';

/// Pantalla interactiva GENÉRICA con preguntas
/// Funciona para cualquier módulo (financiero o ambiental)
class InteractiveScreen extends StatefulWidget {
  final List<dynamic> topics;
  final Color moduleColor;

  const InteractiveScreen({
    super.key,
    required this.topics,
    required this.moduleColor,
  });

  @override
  State<InteractiveScreen> createState() => _InteractiveScreenState();
}

class _InteractiveScreenState extends State<InteractiveScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool showResults = false;
  List<bool> answersStatus = [];

  // Lista de preguntas dinámica basada en los temas recibidos
  late List<Map<String, dynamic>> questions;

  @override
  void initState() {
    super.initState();
    questions = _buildQuestionsFromTopics();
  }

  /// Genera preguntas dinámicamente según los temas del módulo
  List<Map<String, dynamic>> _buildQuestionsFromTopics() {
    // Preguntas específicas según el ID del tema
    final Map<String, Map<String, dynamic>> questionBank = {
      // ===== MÓDULO FINANCIERO =====
      'ahorro': {
        'question': '¿Qué es más importante en el ahorro?',
        'options': ['La cantidad', 'La constancia', 'El lugar donde guardas'],
        'correct': 1,
      },
      'credito': {
        'question': '¿Cuál es una regla de oro del crédito?',
        'options': [
          'Usarlo para gastos innecesarios',
          'Pedir lo máximo posible',
          'Pagar a tiempo para tener buen récord',
        ],
        'correct': 2,
      },
      'interes': {
        'question': '¿Qué debes hacer antes de pedir un préstamo?',
        'options': [
          'No preguntar la tasa de interés',
          'Comparar tasas de interés',
          'Pedir el doble de lo que necesitas',
        ],
        'correct': 1,
      },
      'presupuesto': {
        'question': '¿Cuál es el primer paso para hacer un presupuesto?',
        'options': [
          'Gastar sin control',
          'Registrar ingresos y gastos',
          'Solo ahorrar sin planificar',
        ],
        'correct': 1,
      },
      // ===== MÓDULO AMBIENTAL =====
      'medio_ambiente': {
        'question': '¿Qué es el medio ambiente?',
        'options': [
          'Solo los árboles',
          'Todo lo que nos rodea en el planeta',
          'Solo el agua',
        ],
        'correct': 1,
      },
      'cambio_climatico': {
        'question': '¿Cuál es una consecuencia del cambio climático?',
        'options': [
          'Más árboles',
          'Lluvias más potentes y sequías',
          'Aire más limpio',
        ],
        'correct': 1,
      },
      'causas': {
        'question': '¿Cuál es una causa del cambio climático?',
        'options': [
          'Reciclar',
          'Plantar árboles',
          'Deforestación y mal uso del agua',
        ],
        'correct': 2,
      },
      'como_cuidar': {
        'question': '¿Cuál acción ayuda a cuidar el ambiente?',
        'options': [
          'Usar plásticos de un solo uso',
          'Reciclar papel, latas y vidrio',
          'Dejar luces encendidas',
        ],
        'correct': 1,
      },
      'beneficios': {
        'question': '¿Qué beneficio obtienes al cuidar el ambiente?',
        'options': [
          'Solo beneficios ambientales',
          'Reduces gastos y ayudas al planeta',
          'Ningún beneficio',
        ],
        'correct': 1,
      },
      'reto_familiar': {
        'question': '¿Cómo participas en el reto familiar?',
        'options': [
          'Enviando una foto familiar al WhatsApp',
          'Llamando por teléfono',
          'Visitando la oficina',
        ],
        'correct': 0,
      },

      // ===== MÓDULO EMPODERAMIENTO BÍBLICO =====
      'identidad': {
        'question': '¿Qué dice la Biblia sobre tu identidad?',
        'options': [
          'Que soy solo un pecador',
          'Que fui creado a imagen y semejanza de Dios',
          'Que soy insignificante',
        ],
        'correct': 1,
      },
      'vision': {
        'question': '¿Qué nos ayuda a vivir con propósito?',
        'options': [
          'Vivir el día a día sin planes',
          'Una visión clara de nuestro futuro',
          'Solo trabajar sin descanso',
        ],
        'correct': 1,
      },
      'relaciones': {
        'question': '¿Cómo derribamos los muros del prejuicio?',
        'options': [
          'Ignorando a los demás',
          'Con empatía y compasión',
          'Discutiendo con otros',
        ],
        'correct': 1,
      },
      'plan_de_vida': {
        'question': '¿Qué es un plan de vida?',
        'options': [
          'Una lista de quehaceres diarios',
          'Un mapa personal para alcanzar el éxito',
          'Un documento sin importancia',
        ],
        'correct': 1,
      },
      'plenitud': {
        'question': '¿Qué es Visión de Plenitud?',
        'options': [
          'Un programa solo para líderes',
          'Un programa de empoderamiento con principios bíblicos',
          'Un curso de finanzas',
        ],
        'correct': 1,
      },
      'compromisos': {
        'question': '¿Con quién debes comprometerte primero?',
        'options': [
          'Solo con mi negocio',
          'Solo con mi familia',
          'Con mi negocio, mi familia y conmigo mismo',
        ],
        'correct': 2,
      },
    };

    // Construir la lista de preguntas para los temas actuales
    return widget.topics.map<Map<String, dynamic>>((topic) {
      final data =
          questionBank[topic.id] ??
          {
            'question': '¿Conoces sobre ${topic.title}?',
            'options': ['Sí', 'No', 'Tal vez'],
            'correct': 0,
          };
      return {
        'question': data['question'],
        'options': data['options'],
        'correct': data['correct'],
        'topicId': topic.id,
      };
    }).toList();
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      showResults = false;
      answersStatus = [];
    });
  }

  void handleAnswer(int selectedIndex) {
    final isCorrect =
        selectedIndex == questions[currentQuestionIndex]['correct'];

    setState(() {
      answersStatus.add(isCorrect);
      if (isCorrect) score++;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
        } else {
          showResults = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulo Interactivo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: showResults ? _buildResults() : _buildQuestion(),
      ),
    );
  }

  Widget _buildResults() {
    final porcentaje = (score / questions.length * 100).round();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: porcentaje >= 70 ? Colors.green[100] : Colors.orange[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              porcentaje >= 70 ? Icons.emoji_events : Icons.school,
              size: 50,
              color: porcentaje >= 70
                  ? const Color.fromARGB(255, 68, 219, 76)
                  : Colors.orange[700],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '¡Completaste el módulo!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A5276),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Puntuación: $score / ${questions.length}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            '$porcentaje% de respuestas correctas',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          // Resultados por tema
          ...widget.topics.map((topic) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      porcentaje >= 70 ? Icons.check_circle : Icons.cancel,
                      color: porcentaje >= 70 ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        topic.title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      porcentaje >= 70 ? '✅ Correcto' : '❌ Revisa',
                      style: TextStyle(
                        fontSize: 12,
                        color: porcentaje >= 70
                            ? Colors.green[700]
                            : Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: resetQuiz,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.moduleColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    final question = questions[currentQuestionIndex];
    final options = List<String>.from(question['options']);
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(widget.moduleColor),
        ),
        const SizedBox(height: 12),
        Text(
          'Pregunta ${currentQuestionIndex + 1} de ${questions.length}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.moduleColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            question['question'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: widget.moduleColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: InkWell(
                    onTap: () => handleAnswer(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: widget.moduleColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.moduleColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              options[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
