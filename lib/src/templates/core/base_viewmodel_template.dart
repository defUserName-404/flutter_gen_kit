const String baseViewModelTemplate = r'''
import 'package:flutter/material.dart';

// Base ViewModel for common logic and ChangeNotifier
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Example for handling asynchronous operations
  Future<void> runCatching(Future<void> Function() block) async {
    setLoading(true);
    setErrorMessage(null);
    try {
      await block();
    } catch (e) {
      setErrorMessage(e.toString());
      // Optionally log error here
    } finally {
      setLoading(false);
    }
  }
}
''';
