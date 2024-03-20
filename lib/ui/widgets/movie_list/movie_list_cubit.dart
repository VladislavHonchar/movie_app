import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:movie_app/domain/blocs/movie_list_bloc.dart';
import 'package:movie_app/domain/entity/movie.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MovieListRowData {
  final int id;
  final String title;
  final String releaseDate;
  final String overview;
  final String? posterPath;

  MovieListRowData({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.overview,
    required this.posterPath,
  });
}

class MovieListCubitState {
  final List<MovieListRowData> movies;
  final String localTag;

  MovieListCubitState({
    required this.movies,
    required this.localTag,
  });

  @override
  bool operator ==(covariant MovieListCubitState other) {
    if (identical(this, other)) return true;

    return listEquals(other.movies, movies) &&
        other.localTag == localTag ;
  }

  @override
  int get hashCode =>
      movies.hashCode ^ localTag.hashCode;

  MovieListCubitState copyWith({
    List<MovieListRowData>? movies,
    String? localTag,
    String? searchQuery,
  }) {
    return MovieListCubitState(
      movies: movies ?? this.movies,
      localTag: localTag ?? this.localTag,
    );
  }
}

class MovieListCubit extends Cubit<MovieListCubitState> {
  final MovieListBloc movieListBloc;
  late final StreamSubscription<MovieListState> movieListBlocSubscription;
  late DateFormat _dateFormat;
  Timer? searchDebounce;

  MovieListCubit({
    required this.movieListBloc,
  }) : super(MovieListCubitState(movies: <MovieListRowData>[], localTag: "")){
    Future.microtask((){
    _onState(movieListBloc.state);
    movieListBlocSubscription = movieListBloc.stream.listen(_onState);
    });
  }

  void _onState(MovieListState state){
    final movies = state.movies.map(_makeRowData).toList();
    final newState = this.state.copyWith(movies: movies);
    emit(newState);
  }

  void showMovieAtIndex(int index){
    if(index < state.movies.length - 1) return;
    movieListBloc.add(MovieListEventLoadNextPage(state.localTag));
  }

  Future<void> searchMovie(String text) async{
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(seconds: 1), () async {
      movieListBloc.add(MovieListEventLoadSearchMovie(text));
      movieListBloc.add(MovieListEventLoadNextPage(state.localTag));
    });
    
  }

  void setupLocale(String localeTag) {
    if(state.localTag == localeTag) return;
    final newState = state.copyWith(localTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    movieListBloc.add(MovieListEventLoadReset());
    movieListBloc.add(MovieListEventLoadNextPage(localeTag));
  }

  @override
  Future<void> close() {
    movieListBlocSubscription.cancel();
    return super.close();
  }

  MovieListRowData _makeRowData(Movie movie){
    final releaseDate = movie.releaseDate;
    final releaseDateTitle = releaseDate != null ? _dateFormat.format(releaseDate) : '';
    return MovieListRowData(
      id: movie.id, 
      title: movie.title, 
      releaseDate: releaseDateTitle, 
      overview: movie.overview, 
      posterPath: movie.posterPath,
      );
  }
}
