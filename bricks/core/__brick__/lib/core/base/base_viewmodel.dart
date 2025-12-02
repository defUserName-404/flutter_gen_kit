import 'package:flutter/material.dart';

import '../config/app_logger.dart';

// Base View Model for common logic and ChangeNotifier
abstract class BaseViewmodel extends ChangeNotifier {
  final AppLogger logger;
  bool _isLoading = false;
  String? _errorMessage;

  BaseModel(this.logger);

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
    } catch (e, stackTrace) {
      logger.e('Error in BaseModel', e, stackTrace);
      setErrorMessage(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
