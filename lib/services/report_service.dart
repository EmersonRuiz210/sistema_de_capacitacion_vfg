// SERVICIO DE GENERACIÓN DE REPORTES
// PDF y Excel
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'api_service.dart';

class ReportService {
  // HELPERS SEGUROS DE CONVERSIÓN

  /// Convierte cualquier valor a double de forma segura
  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  /// Convierte cualquier valor a int de forma segura
  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  /// Convierte cualquier valor a String de forma segura
  static String _toStr(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// Formatea una fecha de forma segura (corta)
  static String _formatDate(dynamic value) {
    if (value == null) return '-';
    final str = value.toString();
    return str.length >= 10 ? str.substring(0, 10) : str;
  }

  // GENERAR PDF GENERAL
  static Future<void> generatePDFReport(BuildContext context) async {
    try {
      _showLoading(context);

      final data = await ApiService.getReportData();
      final reporte = data['reporte'] as List<dynamic>;

      // Agrupar por usuario
      final usuariosMap = <int, Map<String, dynamic>>{};
      for (final row in reporte) {
        final userId = row['id_usuario'] as int;
        if (!usuariosMap.containsKey(userId)) {
          usuariosMap[userId] = {
            'info': {
              'nombres': row['nombres'],
              'apellidos': row['apellidos'],
              'email': row['email'],
              'rol': row['nombre_rol'],
              'fecha_registro': row['fecha_registro'],
            },
            'intentos': <dynamic>[],
          };
        }
        if (row['id_intento'] != null) {
          final userEntry = usuariosMap[userId]!;
          final intentos = userEntry['intentos'] as List<dynamic>;
          intentos.add(row);
        }
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Sistema de Capacitación VFG',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Reporte General de Usuarios',
                    style: const pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Fecha: ${DateTime.now().toString().substring(0, 16)}',
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey600,
                    ),
                  ),
                  pw.Divider(),
                ],
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _pdfStat('Total Usuarios', '${usuariosMap.length}'),
                  _pdfStat(
                    'Total Intentos',
                    '${usuariosMap.values.fold<int>(0, (sum, u) => sum + (u['intentos'] as List).length)}',
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Detalle por Usuario',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            ...usuariosMap.entries.map((entry) {
              final info = entry.value['info'];
              final intentos = entry.value['intentos'] as List;

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 16),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '${info['nombres']} ${info['apellidos']}',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          info['rol'].toString().toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColors.orange700,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      info['email'],
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    if (intentos.isEmpty)
                      pw.Text(
                        'Sin intentos registrados',
                        style: const pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey500,
                        ),
                      )
                    else
                      pw.TableHelper.fromTextArray(
                        headers: ['Curso', 'Evaluación', 'Puntaje', 'Fecha'],
                        data: intentos.map((i) {
                          return [
                            _toStr(i['curso_titulo']),
                            _toStr(i['evaluacion_titulo']),
                            '${_toDouble(i['puntaje_obtenido']).toStringAsFixed(1)}/${_toDouble(i['puntaje_maximo']).toStringAsFixed(0)}',
                            _formatDate(i['fecha_intento']),
                          ];
                        }).toList(),
                        headerStyle: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                        headerDecoration: const pw.BoxDecoration(
                          color: PdfColors.blue800,
                        ),
                        cellStyle: const pw.TextStyle(fontSize: 8),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      );

      if (context.mounted) Navigator.pop(context);

      await Printing.layoutPdf(
        onLayout: (format) => pdf.save(),
        name:
            'reporte_capacitaciones_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showError(context, 'Error al generar PDF: $e');
      }
    }
  }

  static pw.Widget _pdfStat(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
      ],
    );
  }

  // GENERAR PDF DE UN USUARIO ESPECÍFICO
  static Future<void> generateUserPDFReport(
    BuildContext context,
    int userId,
    String userName,
  ) async {
    try {
      _showLoading(context);

      final data = await ApiService.getAdminUserDetail(userId);
      final user = data['user'] ?? {};
      final progreso = data['progreso'] as List<dynamic>? ?? [];
      final logros = data['logros'] as List<dynamic>? ?? [];
      final intentos = data['intentos'] as List<dynamic>? ?? [];
      final stats = data['estadisticas'] ?? {};

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Reporte de Usuario',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Sistema de Capacitación VFG',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.Divider(),
                ],
              ),
            ),
            pw.Text(
              'Información del Usuario',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Nombre: ${_toStr(user['nombres'])} ${_toStr(user['apellidos'])}',
            ),
            pw.Text('Email: ${_toStr(user['email'])}'),
            pw.Text('Rol: ${_toStr(user['nombre_rol'])}'),
            pw.SizedBox(height: 16),
            pw.Text(
              'Estadísticas',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _pdfStat(
                  'Intentos',
                  _toInt(stats['total_intentos']).toString(),
                ),
                _pdfStat(
                  'Promedio',
                  _toDouble(stats['promedio_puntaje']).toStringAsFixed(1),
                ),
                _pdfStat(
                  'Mejor',
                  _toDouble(stats['mejor_puntaje']).toStringAsFixed(1),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Progreso por Curso',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: ['Curso', 'Progreso', 'Completados'],
              data: progreso.map((p) {
                return [
                  _toStr(p['curso_titulo']),
                  '${_toDouble(p['promedio_progreso']).toStringAsFixed(1)}%',
                  '${_toInt(p['modulos_completados'])}/${_toInt(p['total_modulos'])}',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Logros Obtenidos (${logros.length})',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            if (logros.isEmpty)
              pw.Text(
                'Sin logros',
                style: const pw.TextStyle(color: PdfColors.grey600),
              )
            else
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: logros.map((l) {
                  return pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.amber100,
                      borderRadius: pw.BorderRadius.circular(12),
                    ),
                    child: pw.Text(
                      _toStr(l['titulo']),
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  );
                }).toList(),
              ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Historial de Intentos (${intentos.length})',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            if (intentos.isEmpty)
              pw.Text(
                'Sin intentos',
                style: const pw.TextStyle(color: PdfColors.grey600),
              )
            else
              pw.TableHelper.fromTextArray(
                headers: ['Curso', 'Evaluación', 'Puntaje', 'Fecha'],
                data: intentos.map((i) {
                  return [
                    _toStr(i['curso_titulo']),
                    _toStr(i['evaluacion_titulo']),
                    '${_toDouble(i['puntaje_obtenido']).toStringAsFixed(1)}/${_toDouble(i['puntaje_maximo']).toStringAsFixed(0)}',
                    _formatDate(i['fecha_intento']),
                  ];
                }).toList(),
              ),
          ],
        ),
      );

      if (context.mounted) Navigator.pop(context);

      await Printing.layoutPdf(
        onLayout: (format) => pdf.save(),
        name:
            'reporte_${_toStr(user['nombres'])}_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showError(context, 'Error: $e');
      }
    }
  }

  // UTILIDADES
  static void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Generando reporte...'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
