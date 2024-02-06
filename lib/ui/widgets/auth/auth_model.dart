import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/data_provider/session_data_provider.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier{
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (login.isEmpty || password.isEmpty){
      _errorMessage = "Please, enter your login or password";
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isAuthProgress = true;
    notifyListeners();
    String? sessionId;
    try{
    sessionId = await _apiClient.auth(
      username: login, 
      password: password
      );
    }on ApiClientExeption catch(e){
      switch(e.type){
        case ApiClientExeptionType.Network:
        _errorMessage = "Сервер недоступний, перевірте з'єднання з інтернетом";
        break;
        case ApiClientExeptionType.Auth:
        _errorMessage = "Невірний логін або пароль";
        break;
        case ApiClientExeptionType.Other:
        _errorMessage = "Відбулась помилка. Спробуйте ще раз";
        break;
      }
    }
      _isAuthProgress = false;
      if(_errorMessage != null || sessionId == null){
      notifyListeners();
      return;
      }
     await _sessionDataProvider.setSessionId(sessionId);
     unawaited(Navigator.of(context).pushReplacementNamed(MainNavigationRouteName.mainScreen));
  }
}


