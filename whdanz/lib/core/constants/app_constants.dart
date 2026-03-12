import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFFEC4899);
  static const Color accent = Color(0xFF14B8A6);
  
  static const Color background = Color(0xFF0F0F0F);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);
  
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  
  static const Color poseCorrect = Color(0xFF22C55E);
  static const Color poseIncorrect = Color(0xFFEF4444);
  static const Color poseWarning = Color(0xFFF59E0B);
}

class AppDimensions {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
}

class AppStrings {
  static const String appName = 'WhDanz';
  static const String tagline = 'Mejora tu baile con IA';
  
  // Auth
  static const String login = 'Iniciar sesión';
  static const String register = 'Registrarse';
  static const String email = 'Correo electrónico';
  static const String password = 'Contraseña';
  static const String confirmPassword = 'Confirmar contraseña';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';
  static const String noAccount = '¿No tienes cuenta?';
  static const String hasAccount = '¿Ya tienes cuenta?';
  
  // Navigation
  static const String feed = 'Feed';
  static const String camera = 'Cámara';
  static const String map = 'Mapa';
  static const String profile = 'Perfil';
  
  // Pose Detection
  static const String startPractice = 'Iniciar práctica';
  static const String selectPose = 'Seleccionar pose';
  static const String yourScore = 'Tu puntuación';
  static const String feedback = 'Feedback';
  
  // Places
  static const String addPlace = 'Añadir lugar';
  static const String places = 'Lugares';
  static const String reviews = 'Reseñas';
}
