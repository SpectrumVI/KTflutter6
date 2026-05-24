import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String get userEmail => _user?.email ?? 'пользователь';

  AuthProvider() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> loginWithEmail({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(), 
        password: password,
      );
      
      print('Вход успешен: ${credential.user?.email}');
      
      await saveLoginStatus(true);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.message ?? 'Ошибка входа';
      notifyListeners();
      print('Ошибка входа: ${e.code}');
      return false;
    }
  }

  Future<bool> registerWithEmail({required String email, required String password}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), 
        password: password,
      );
      
      print('Регистрация успешна: ${credential.user?.email}');
      
      await saveLoginStatus(true);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.message ?? 'Ошибка регистрации';
      notifyListeners();
      print('Ошибка регистрации: ${e.code}');
      return false;
    }
  }

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await saveLoginStatus(false);
    notifyListeners();
  }
}