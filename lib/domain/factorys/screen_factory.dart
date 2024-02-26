import 'package:flutter/material.dart';
import 'package:movie_app/domain/library/widgets/inherited/provider.dart' as old_provider;
import 'package:movie_app/ui/widgets/auth/auth_model.dart';
import 'package:movie_app/ui/widgets/auth/auth_widget.dart';
import 'package:movie_app/ui/widgets/loader_widget/loader_view_model.dart';
import 'package:movie_app/ui/widgets/loader_widget/loader_widget.dart';
import 'package:movie_app/ui/widgets/main_screen/main_screen_model.dart';
import 'package:movie_app/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_module.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:movie_app/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  Widget makeLoader(){
    return Provider(
      create: (context) => LoaderViewModel(context), 
      lazy: false,
      child: const LoaderWidget()
      );
  }

  Widget makeAuth(){
    return ChangeNotifierProvider(
      create: (_) => AuthModel(),
      child: const AuthWidget(),
      );
  }

  Widget makeMainScreen(){
    return old_provider.NotifierProvider(
      create: () => MainScreenModel(),
      child: const MainScreenWidget(),
      );
  }

  Widget makeMovieDetails(int movieId){
    return old_provider.NotifierProvider(
      create: () => MovieDetailsModel(movieId: movieId),
      child: const MovieDetailWidget(),
      );
  }
  Widget makeMovieTrailer(String youTubeKey){
    return MovieTrailerWidget(youtubeKey: youTubeKey);
  }
}
  
