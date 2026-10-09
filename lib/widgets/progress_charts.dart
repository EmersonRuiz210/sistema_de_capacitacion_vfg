//GRÁFICOS DE PROGRESO
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../utils/colors.dart';

// GRÁFICO CIRCULAR: Progreso general
class GeneralProgressChart extends StatelessWidget {
  final double porcentaje; // 0-100
  final String title;

  const GeneralProgressChart({
    super.key,
    required this.porcentaje,
    this.title = 'Progreso general',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A5276),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      value: porcentaje,
                      color: AppColors.primaryBlue,
                      radius: 25,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      value: 100 - porcentaje,
                      color: Colors.grey[200]!,
                      radius: 20,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${porcentaje.round()}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A5276),
                    ),
                  ),
                  Text(
                    'Completado',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// GRÁFICO DE BARRAS: Progreso por curso
class CoursesBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  // Cada curso: {'name': 'Educación Financiera', 'progress': 75.0, 'color': Color}

  const CoursesBarChart({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calcular el máximo para escalar
    final maxProgress = courses
        .map((c) => (c['progress'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
    final maxY = maxProgress < 100 ? 100.0 : (maxProgress * 1.2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparación por curso',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A5276),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${courses[group.x.toInt()]['name']}\n${rod.toY.round()}%',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= courses.length) {
                        return const SizedBox.shrink();
                      }
                      // Abreviar nombres
                      final name = courses[index]['name'] as String;
                      final shortName = name.split(' ').first;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          shortName,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey[200]!, strokeWidth: 1);
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: courses.asMap().entries.map((entry) {
                final index = entry.key;
                final course = entry.value;
                final progress = (course['progress'] as num).toDouble();
                final color = course['color'] as Color;

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: progress,
                      color: color,
                      width: 30,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

// GRÁFICO DE LÍNEA: Evolución de puntajes
class ScoreEvolutionChart extends StatelessWidget {
  final List<Map<String, dynamic>> attempts;
  // Cada attempt: {'date': DateTime, 'score': 75.0}

  const ScoreEvolutionChart({super.key, required this.attempts});

  @override
  Widget build(BuildContext context) {
    if (attempts.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.show_chart, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Aún no hay datos suficientes',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Ordenar por fecha (ascendente)
    final sortedAttempts = List<Map<String, dynamic>>.from(
      attempts,
    )..sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    // Crear los puntos
    final spots = sortedAttempts.asMap().entries.map((entry) {
      final index = entry.key;
      final score = (entry.value['score'] as num).toDouble();
      return FlSpot(index.toDouble(), score);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Evolución de puntajes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A5276),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 100,
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        'Intento ${spot.x.toInt() + 1}\n${spot.y.round()} pts',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: Colors.grey[200]!, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    interval: 25,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '#${value.toInt() + 1}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.primaryBlue,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 5,
                        color: AppColors.primaryBlue,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
