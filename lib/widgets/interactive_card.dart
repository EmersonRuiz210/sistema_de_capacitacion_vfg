import 'package:flutter/material.dart';
import '../models/financial.dart';

/// Tarjeta pequeña que muestra el resultado del módulo interactivo
/// Indica si el usuario respondió correctamente sobre ese tema
class InteractiveCard extends StatelessWidget {
  final FinancialTopic topic;
  final bool isCorrect;

  const InteractiveCard({
    super.key,
    required this.topic,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
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
            // Icono según si acertó o no
            Icon(
              isCorrect ? Icons.check_circle : Icons.cancel,
              color: isCorrect ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 12),
            // Nombre del tema
            Expanded(
              child: Text(
                topic.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Etiqueta de estado
            Text(
              isCorrect ? '✅ Correcto' : '❌ Revisa',
              style: TextStyle(
                fontSize: 12,
                color: isCorrect ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}