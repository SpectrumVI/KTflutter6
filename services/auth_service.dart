import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис-обёртка над Firebase Auth.
/// Отвечает за прямые вызовы к Firebase и локальное сохранение статуса.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Поток изменений состояния авторизации (главный источник)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Текущий пользователь
  User? get currentUser => _auth.currentUser;

  /// Регистрация с Email и Паролем.
  /// Возвращает созданного пользователя или выбрасывает исключение.
  Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Вход с Email и Паролем.
  Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Выход из аккаунта в Firebase + очистка локального флага.
  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  /// Сохранить факт успешного входа локально (для быстрой проверки).
  Future<void> saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  /// Проверить локальный флаг (на случай, если Firebase ещё не ответил).
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}