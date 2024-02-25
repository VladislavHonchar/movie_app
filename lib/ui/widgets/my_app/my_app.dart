import 'package:flutter/material.dart';
import 'package:movie_app/Theme/app_colors.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  //final MyAppModel model;
  static final mainNavigation = MainNavigation(); 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.mainDarkBlue,
        ),
        useMaterial3: true,
        bottomNavigationBarTheme:const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey
        ),
         
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const[
        Locale('ru', 'RU'),
        Locale('en', 'US'),
        Locale('uk', 'UA'),
        Locale('hy', 'AM'),
      ],
      routes: mainNavigation.routes,
      initialRoute: MainNavigationRouteName.loaderWidget,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}