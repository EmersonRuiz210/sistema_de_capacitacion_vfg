import 'package:flutter/material.dart';

import '../models/training.dart';
import '../widgets/module_card.dart';
import 'topic_list_screen.dart';
import '../models/financial.dart';
import '../models/ambiental.dart';
import '../models/empoderamiento.dart';

/// Pantalla principal que muestra los MÓDULOS disponibles
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = TrainingModule.getModules();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capacitaciones VFG'),
        foregroundColor: const Color(0xFF1A5276),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F6FA), Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A5276),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Elige el módulo de capacitación que quieres aprender',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Lista de módulos
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: modules.length,
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return ModuleCard(
                    module: module,
                    onTap: () => _openModule(context, module),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Abre el módulo seleccionado según su tipo
  void _openModule(BuildContext context, TrainingModule module) {
    // Cargar los temas según el tipo de módulo
    List<dynamic> topics;
    switch (module.id) {
      case 'financiero':
        topics = FinancialTopic.getTopics();
        break;
      case 'ambiental':
        topics = EnvironmentalTopic.getTopics();
        break;
      case 'empoderamiento':
        topics = EmpowermentTopic.getTopics();
        break;
      default:
        topics = [];
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicListScreen(
          moduleTitle: module.title,
          moduleColor: module.color,
          topics: topics,
        ),
      ),
    );
  }
}
