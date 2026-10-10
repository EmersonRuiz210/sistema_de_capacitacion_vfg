// PANEL DE ADMINISTRACIÓN

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'admin_user_detail_screen.dart';
import '../services/report_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, dynamic>? dashboard;
  List<dynamic> users = [];
  bool isLoading = true;
  String? errorMessage;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final dashData = await ApiService.getAdminDashboard();
      final usersData = await ApiService.getAdminUsers();

      if (!mounted) return;
      setState(() {
        dashboard = dashData;
        users = usersData;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  //HELPERS SEGUROS

  /// Convierte cualquier valor a String de forma segura
  String _str(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// Convierte cualquier valor a int de forma segura
  int _int(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  /// Convierte cualquier valor a double de forma segura
  double _double(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        foregroundColor: Colors.orange[800],
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
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
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando panel...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [_buildTab('Dashboard', 0), _buildTab('Usuarios', 1)],
          ),
        ),
        Expanded(
          child: _currentTab == 0 ? _buildDashboard() : _buildUsersList(),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.orange[800]! : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.orange[800] : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  //DASHBOARD
  Widget _buildDashboard() {
    final stats = dashboard?['estadisticas'] as Map<String, dynamic>? ?? {};
    final topUsuarios = dashboard?['top_usuarios'] as List<dynamic>? ?? [];
    final topLogros = dashboard?['top_logros'] as List<dynamic>? ?? [];

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas globales',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5276),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.people,
                    value: _int(stats['total_usuarios']).toString(),
                    label: 'Usuarios',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.quiz,
                    value: _int(stats['total_intentos']).toString(),
                    label: 'Intentos',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up,
                    value: _double(stats['promedio_global']).toStringAsFixed(1),
                    label: 'Promedio',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.emoji_events,
                    value: _int(stats['total_logros_obtenidos']).toString(),
                    label: 'Logros',
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              'Usuarios más activos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5276),
              ),
            ),
            const SizedBox(height: 12),
            if (topUsuarios.isEmpty)
              _buildEmpty('Sin datos de usuarios')
            else
              ...topUsuarios.asMap().entries.map((entry) {
                final index = entry.key;
                final user = entry.value as Map<String, dynamic>;
                return _buildTopUserCard(index + 1, user);
              }),

            const SizedBox(height: 32),

            const Text(
              'Logros más obtenidos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5276),
              ),
            ),
            const SizedBox(height: 12),
            if (topLogros.isEmpty)
              _buildEmpty('Sin datos de logros')
            else
              ...topLogros.map((logro) {
                return _buildTopAchievementCard(logro as Map<String, dynamic>);
              }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(message, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildTopUserCard(int position, Map<String, dynamic> user) {
    final colors = [Colors.amber, Colors.grey[400]!, Colors.brown[400]!];
    final color = position <= 3 ? colors[position - 1] : Colors.blue;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(
            position.toString(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          '${_str(user['nombres'])} ${_str(user['apellidos'])}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${_int(user['total_intentos'])} intentos'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${_double(user['promedio']).toStringAsFixed(0)} pts',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopAchievementCard(Map<String, dynamic> logro) {
    final total = _int(logro['total_obtenidos']);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.amber.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.emoji_events, color: Colors.amber),
        ),
        title: Text(
          _str(logro['titulo']),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$total usuarios',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  //USUARIOS
  Widget _buildUsersList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => ReportService.generatePDFReport(context),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('PDF General'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        Expanded(
          child: users.isEmpty
              ? _buildEmpty('No hay usuarios registrados')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(users[index] as Map<String, dynamic>);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final rol = _str(user['nombre_rol']);
    final rolColor = rol == 'admin'
        ? Colors.orange
        : rol == 'asesor'
        ? Colors.blue
        : Colors.grey;

    final nombres = _str(user['nombres']);
    final inicial = nombres.isNotEmpty ? nombres[0].toUpperCase() : '?';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdminUserDetailScreen(
                userId: _int(user['id_usuario']),
                userName: '${_str(user['nombres'])} ${_str(user['apellidos'])}',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: rolColor.withValues(alpha: 0.15),
                    child: Text(
                      inicial,
                      style: TextStyle(
                        color: rolColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_str(user['nombres'])} ${_str(user['apellidos'])}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _str(user['email']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: rolColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      rol.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: rolColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMiniStat(
                    'Intentos',
                    _int(user['total_intentos']).toString(),
                    Colors.blue,
                  ),
                  _buildMiniStat(
                    'Promedio',
                    _double(user['promedio_puntaje']).toStringAsFixed(0),
                    Colors.green,
                  ),
                  _buildMiniStat(
                    'Logros',
                    _int(user['total_logros']).toString(),
                    Colors.amber,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
