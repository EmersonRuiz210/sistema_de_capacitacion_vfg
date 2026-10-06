// SERVICIO DE API - Comunicación con el backend

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static String? _token;

  // GESTIÓN DEL TOKEN
  /// Cargar token guardado al iniciar la app
  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  /// Guardar token después del login/registro
  static Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Cerrar sesión
  static Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  /// Verificar si hay sesión activa
  static bool get isLoggedIn => _token != null;

  /// Headers comunes con autenticación
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // MÉTODOS HTTP GENÉRICOS
  /// Petición GET
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  /// Petición POST
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  /// Manejo de respuestas HTTP
  static dynamic _handleResponse(http.Response response) {
    dynamic data;
    try {
      data = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Respuesta inválida del servidor');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Error ${response.statusCode}');
    }
  }

  // AUTENTICACIÓN
  /// Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final data = await post('/auth/login', {
      'email': email,
      'password': password,
    });
    await saveToken(data['token']);

    // Guardar datos del usuario
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(data['user']));

    return data;
  }

  /// Registro
  static Future<Map<String, dynamic>> register({
    required String nombres,
    required String apellidos,
    required String email,
    required String password,
    String? telefono,
  }) async {
    final data = await post('/auth/register', {
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'password': password,
      'telefono': telefono,
    });
    await saveToken(data['token']);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(data['user']));

    return data;
  }

  /// Obtener datos del usuario guardado localmente
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData == null) return null;
    return jsonDecode(userData);
  }

  // CURSOS
  /// Obtener todos los cursos
  static Future<List<dynamic>> getCourses() async {
    final data = await get('/courses');
    return data['courses'] ?? [];
  }

  /// Obtener módulos de un curso
  static Future<List<dynamic>> getCourseModules(int courseId) async {
    final data = await get('/courses/$courseId/modules');
    return data['modules'] ?? [];
  }

  /// Obtener contenidos de un módulo
  static Future<List<dynamic>> getModuleContents(int moduleId) async {
    final data = await get('/modules/$moduleId/contents');
    return data['contents'] ?? [];
  }

  // PROGRESO
  /// Guardar progreso de un módulo
  static Future<void> saveProgress(int moduleId, double percentage) async {
    await post('/progress', {
      'id_modulo': moduleId,
      'porcentaje_completado': percentage,
    });
  }

  /// Obtener progreso por curso
  static Future<Map<String, dynamic>> getCourseProgress(int courseId) async {
    return await get('/progress/course/$courseId');
  }

  /// Obtener todo mi progreso
  static Future<List<dynamic>> getMyProgress() async {
    final data = await get('/progress');
    return data['progress'] ?? [];
  }

  // EVALUACIONES
  /// Obtener evaluación de un módulo
  static Future<Map<String, dynamic>> getModuleEvaluation(int moduleId) async {
    final data = await get('/modules/$moduleId/evaluation');
    return data['evaluation'];
  }

  /// Guardar intento de evaluación
  /// [evaluationId] ID de la evaluación
  /// [puntaje] Puntaje obtenido (ej: 75.0)
  /// [respuestas] Lista de respuestas del usuario (opcional)
  static Future<Map<String, dynamic>> saveAttempt({
    required int evaluationId,
    required double puntaje,
    List<Map<String, dynamic>>? respuestas,
  }) async {
    final data = await post('/evaluations/$evaluationId/attempt', {
      'puntaje_obtenido': puntaje,
      if (respuestas != null) 'respuestas': respuestas,
    });
    return data;
  }

  /// Obtener mis intentos de una evaluación
  static Future<List<dynamic>> getMyAttempts(int evaluationId) async {
    final data = await get('/evaluations/$evaluationId/attempts');
    return data['attempts'] ?? [];
  }

  /// Obtener todo mi historial de intentos
  static Future<List<dynamic>> getAllMyAttempts() async {
    final data = await get('/evaluations/my-attempts');
    return data['attempts'] ?? [];
  }
}
