import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/domain/blocs/auth_bloc.dart';
import 'package:movie_app/domain/blocs/movie_list_bloc.dart';
import 'package:movie_app/ui/widgets/auth/auth_view_cubit.dart';
import 'package:movie_app/ui/widgets/auth/auth_widget.dart';
import 'package:movie_app/ui/widgets/loader_widget/loader_view_cubit.dart';
import 'package:movie_app/ui/widgets/loader_widget/loader_widget.dart';
import 'package:movie_app/ui/widgets/main_screen/main_screen_model.dart';
import 'package:movie_app/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_module.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:movie_app/ui/widgets/movie_list/movie_list_cubit.dart';
import 'package:movie_app/ui/widgets/movie_list/movie_list_model.dart';
import 'package:movie_app/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:movie_app/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:movie_app/ui/widgets/news_widget/news_widget.dart';
import 'package:movie_app/ui/widgets/tv_shows_widget/tv_shows_widget.dart';
import 'package:provider/provider.dart';

class ScreenFactory {
  AuthBloc? _authBloc;
  
  Widget makeLoader(){
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    return BlocProvider<LoaderViewCubit>(
      create: (context) => LoaderViewCubit(LoaderViewCubitState.unknow, authBloc), 
      child: const LoaderWidget()
      );
  }
  // Widget makeLoader(){
  //   return Provider(
  //     create: (context) => LoaderViewModel(context), 
  //     lazy: false,
  //     child: const LoaderWidget()
  //     );
  // }

  Widget makeAuth(){
    final authBloc = _authBloc ?? AuthBloc(AuthCheckStatusInProgressState());
    _authBloc = authBloc;

    return BlocProvider<AuthViewCubit>(
      create: (_) => AuthViewCubit(
        AuthViewCubitFormFillInProgressState(),
        authBloc
      ),
      child: const AuthWidget(),
    );

    // return ChangeNotifierProvider(
    //   create: (_) => AuthModel(),
    //   child: const AuthWidget(),
    //   );
  }

  Widget makeMainScreen(){
    _authBloc?.close();
    _authBloc = null;
    return  const MainScreenWidget();
  }

  Widget makeMovieDetails(int movieId){
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsModel(movieId: movieId),
      child: const MovieDetailWidget(),
      );
  }
  Widget makeMovieTrailer(String youTubeKey){
    return MovieTrailerWidget(youtubeKey: youTubeKey);
  }

  Widget makeNewsList(){
    return ChangeNotifierProvider(
      create: (_) => MainScreenModel(),
      child: const NewsWidget(),
      );
  }
  Widget makeMovieList(){
    return BlocProvider(
      create: (_) => MovieListCubit(movieListBloc: MovieListBloc( const MovieListState.initial())),
      child: MovieListWidget(),
      );
  }
  Widget makeTvShows(){
    return const TvShowsWidget();
  }
}
  
