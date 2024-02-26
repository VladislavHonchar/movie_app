import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_app/domain/api_client/movie_api_client.dart';
import 'package:movie_app/domain/api_client/api_client_exeption.dart';
import 'package:movie_app/domain/services/auth_service.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _authSerice = AuthService();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty || password.isNotEmpty;

  Future<String?> _login(String login, String password) async {
    try {
      await _authSerice.login(login, password);
    } on ApiClientExeption catch (e) {
      switch (e.type) {
        case ApiClientExeptionType.network:
          return "Сервер недоступний, перевірте з'єднання з інтернетом";
        case ApiClientExeptionType.auth:
          return "Невірний логін або пароль";
        case ApiClientExeptionType.sessionExpired:
          return "Ключ помер";
        case ApiClientExeptionType.other:
          return "Відбулась помилка. Спробуйте ще раз";
      }
    } catch (e) {
      return 'Somthing went wrong';
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (!_isValid(login, password)) {
      _updateState("Please, enter your login or password", false);
      return;
    }
    _updateState(null, true);

    _errorMessage = await _login(login, password);
    if(_errorMessage == null){
      MainNavigation.resetNavigation(context);
    }else{
    _updateState(_errorMessage, false);
    }
  }
  
  void _updateState(String? errorMessage, bool isAuthProgress){
    if(_errorMessage == errorMessage && _isAuthProgress == isAuthProgress){
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
