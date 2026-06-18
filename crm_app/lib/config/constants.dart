import 'package:flutter/material.dart';

class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://uxhbtejqsojwxyqwuceb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV4aGJ0ZWpxc29qd3h5cXd1Y2ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE3NDk0OTIsImV4cCI6MjA5NzMyNTQ5Mn0.Egcx-rU_TSiwUHbqoGC824ZTCsTZuHFVndzQr3gJqTg';

  // User Roles
  static const String roleArchitect = 'architect';
  static const String roleAdmin = 'admin';
  static const String roleHR = 'hr';
  static const String roleStaff = 'staff';

  // Project Categories
  static const String categoryArchitecturalDesign = 'architectural_design';
  static const String categoryDesignLicensing = 'design_licensing';
  static const String categoryPMC = 'pmc';

  // Project Types
  static const String typeResidential = 'residential';
  static const String typeCommercial = 'commercial';
  static const String typeHospital = 'hospital';

  // Project Status
  static const String statusActive = 'active';
  static const String statusOnHold = 'on_hold';
  static const String statusCompleted = 'completed';

  // App Strings
  static const String appName = 'CRM Application';
  static const String appVersion = '1.0.0';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 2.0;
}

class AppColors {
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF66BB6A);
  static const Color primaryDark = Color(0xFF1B5E20);

  static const Color secondary = Color(0xFF1976D2);
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF1565C0);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;

  static const Color text = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color textLighter = Color(0xFFBDBDBD);

  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);
}
