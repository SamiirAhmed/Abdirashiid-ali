import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

// Maareeyaha Xaaladda Aqoonsiga (Auth ViewModel)
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String _error = '';

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.role == 'admin';

  // Constructor - automatically load saved user on creation
  AuthViewModel() {
    init();
  }

  // Bilowga (Init)
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    _user = await _authService.getCurrentUser();
    
    _isLoading = false;
    notifyListeners();
  }

  // Register
  Future<bool> register(String name, String email, String password, String role) async {
    _setLoading(true);
    _error = '';
    
    try {
      await _authService.register(name, email, password, role);
      _user = null; // Don't auto-login after register
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Galitaanka (Login)
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = '';
    
    try {
      _user = await _authService.login(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Ka bixitaanka (Logout)
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
