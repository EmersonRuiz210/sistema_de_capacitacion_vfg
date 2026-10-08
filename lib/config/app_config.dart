// CONFIGURACIÓN GLOBAL DE LA APP

class AppConfig {
  /// URL base del backend según el entorno
  /// Cambia esta línea según dónde estés desplegando:

  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://192.168.0.16:3000/api',
  );

  /// Nombre de la app
  static const String appName = 'Sistema de Capacitacion';

  /// Versión de la app
  static const String appVersion = '1.0.0';
}
