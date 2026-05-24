import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterProvider extends ChangeNotifier {
  int _counter = 0;
  bool _isLoading = true;

  int get counter => _counter;
  bool get isLoading => _isLoading;

  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter') ?? 0;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> increment() async {
    final prefs = await SharedPreferences.getInstance();
    _counter++;
    await prefs.setInt('counter', _counter);
    notifyListeners();
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = 0;
    await prefs.setInt('counter', _counter);
    notifyListeners();
  }
}