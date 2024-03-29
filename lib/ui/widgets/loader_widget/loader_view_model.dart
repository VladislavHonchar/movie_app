import 'package:flutter/material.dart';
import 'package:movie_app/domain/services/auth_service.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';

class LoaderViewModel{
  final BuildContext context;
  final _authService = AuthService();
  LoaderViewModel(this.context){
    asyncInit();
  }
  Future<void> asyncInit() async{
    await checkAuth();
  }

  Future<void> checkAuth() async{
    final isAuth = await _authService.isAuth();
    final nextScreen = isAuth 
    ? MainNavigationRouteName.mainScreen
    : MainNavigationRouteName.auth;
    navigateToScreen(nextScreen);
  }

  void navigateToScreen(String nextScreen) {
    Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}