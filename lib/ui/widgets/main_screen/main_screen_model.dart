import 'package:flutter/material.dart';
import 'package:movie_app/domain/services/auth_service.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';

class MainScreenModel extends ChangeNotifier{
  final _authService = AuthService();

  Future<void> makeLogOutOnPressButton(BuildContext context) async{
    await _authService.logOutUser();
    MainNavigation.resetNavigation(context);
  }
}