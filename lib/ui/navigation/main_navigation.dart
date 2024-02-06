import 'package:flutter/material.dart';
import 'package:movie_app/domain/library/widgets/inherited/provider.dart';
import 'package:movie_app/ui/widgets/auth/auth_model.dart';
import 'package:movie_app/ui/widgets/auth/auth_widget.dart';
import 'package:movie_app/ui/widgets/main_screen/main_screen_model.dart';
import 'package:movie_app/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_widget.dart';

abstract class MainNavigationRouteName{
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieDetails = '/movie_details';
}

class MainNavigation{
  String initialRoute(bool isAuth) => isAuth ? MainNavigationRouteName.mainScreen : MainNavigationRouteName.auth;
  final routes = <String, Widget Function(BuildContext)>{
   MainNavigationRouteName.auth: (context) => NotifierProvider(
          model: AuthModel(), 
          child: const AuthWidget()
          ),
  MainNavigationRouteName.mainScreen: (context) => NotifierProvider(model: MainScreenModel(), child: const MainScreenWidget()) 
  };
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch(settings.name){
      case MainNavigationRouteName.movieDetails:
      final arguments = settings.arguments;
      final movieId = arguments is int ? arguments : 0;
      return MaterialPageRoute(
        builder: (context) => MovieDetailWidget(movieId: movieId),
      );
      default:
      const widget = Text('Navigation error!!!!!');
      return MaterialPageRoute(builder: (context) => widget);
    }
  }
}