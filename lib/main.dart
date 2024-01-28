import 'package:flutter/material.dart';
import 'package:movie_app/Theme/app_colors.dart';
import 'package:movie_app/widgets/auth/auth_widget.dart';
import 'package:movie_app/widgets/main_screen/main_screen_widget.dart';
import 'package:movie_app/widgets/movie_details/movie_details_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
        backgroundColor: AppColors.mainDarkBlue,
        ),
        useMaterial3: true,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey
        ), 
      ),
      routes: {
        '/auth': (context) => AuthWidget(),
        //'/main_screen': (context) => ExampleWodget(),
        '/main_screen': (context) => MainScreenWidget(),
        '/main_screen/movie_details': (context){

          final arguments = ModalRoute.of(context)?.settings.arguments;
          if(arguments is int){
            return MovieDetailWidget(movieId: arguments,);
          }else{
            return MovieDetailWidget(movieId: 1,);
          }
          }
      },
      initialRoute: '/auth',
      // onGenerateRoute: (RouteSettings settings) {
      //   return MaterialPageRoute<void>(builder: (context) {
      //     return Scaffold(body: Center(child: Text("Wrong navigation")));
      //   });
      // },
    );
  }
}

class ExampleWodget extends StatefulWidget {
  const ExampleWodget({super.key});

  @override
  State<ExampleWodget> createState() => _ExampleWodgetState();
}

class _ExampleWodgetState extends State<ExampleWodget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TMDB"),
      ),
      body: Center(
        child:ElevatedButton(onPressed: (){
          if (Navigator.of(context).canPop()){
            Navigator.of(context).pop();
          };
        },
        child: Text("Press :)"),) ),
    );
  }
}


