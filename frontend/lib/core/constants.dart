import 'dart:io';
import 'package:flutter/foundation.dart';

// Meelaha xogta muhiimka ah ay ku kaydsan tahay
class AppConstants {
  // API URL-ka - Automatically handles Emulator vs Web/Desktop
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:5000/api';
    return 'http://localhost:5000/api';
  }
  
  // Magacyada furayaasha Shared Preferences
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
