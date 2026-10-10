// PANTALLA DE INFORME INTELIGENTE
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/colors.dart';

class AiReportScreen extends StatefulWidget {
  final int? userId;
  final String? userName;

  const AiReportScreen({super.key, this.userId, this.userName});

  @override
  State<AiReportScreen> createState() => _AiReportScreenState();
}

class _AiReportScreenState extends State<AiReportScreen> {
  Map<String, dynamic>? informe;
  bool _cargando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generarInforme();
  }

  Future<void> _generarInforme() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final data = await ApiService.generarInformeIA(userId: widget.userId);
      if (!mounted) return;
      setState(() {
        informe = data;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName ?? 'Informe Inteligente'),
        foregroundColor: AppColors.primaryBlue,
        backgroundColor: Colors.white,
        actions: [
          if (informe != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _generarInforme,
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
    if (_cargando) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Generando informe con IA...'),
            SizedBox(height: 8),
            Text(
              'Esto puede tardar unos segundos',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _generarInforme,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (informe == null) {
      return const Center(child: Text('Sin datos'));
    }

    final user = informe!['user'] ?? {};
    final textoInforme = informe!['informe'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  AppColors.primaryBlue.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
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
                        'Informe Inteligente',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        '${user['nombres']} ${user['apellidos']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Generado por Gemini AI',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Informe generado por IA
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.psychology,
                        color: AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Análisis del desempeño',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Renderizar el texto del informe (soporta markdown simple)
                  _buildMarkdownText(textoInforme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Renderiza texto con markdown básico (negritas, viñetas, saltos)
  Widget _buildMarkdownText(String texto) {
    final lineas = texto.split('\n');
    final widgets = <Widget>[];

    for (var linea in lineas) {
      final trimmed = linea.trim();

      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // Detectar títulos con **
      if (trimmed.startsWith('**') &&
          trimmed.endsWith('**') &&
          trimmed.length > 4) {
        final titulo = trimmed.replaceAll('**', '');
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        );
        continue;
      }

      // Detectar viñetas
      if (trimmed.startsWith('- ') || trimmed.startsWith('• ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 15)),
                Expanded(
                  child: Text(
                    trimmed.substring(2),
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      // Detectar numeración
      final regexNumerada = RegExp(r'^\d+\.\s');
      if (regexNumerada.hasMatch(trimmed)) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              trimmed,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        );
        continue;
      }

      // Texto normal
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            trimmed.replaceAll('**', ''),
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
