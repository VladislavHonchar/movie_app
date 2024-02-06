
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier{
  final _apiClient = ApiClient();
  final _movies = <Movie>[];
  List<Movie> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  late String _locale = '';

  String stringFromDate(DateTime? date) => 
  date != null ? _dateFormat.format(date) : '';

  void setupLocale(BuildContext context){
    final locale = Localizations.localeOf(context).toLanguageTag();
    if(_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    _movies.clear();
    loadMovies();
  }

  Future<void> loadMovies() async{
    final moviesResponse = await _apiClient.popularMovie(1, _locale);
    _movies.addAll(moviesResponse.movies);
    notifyListeners();
  }


  void onMovieTap(BuildContext context, int index){
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteName.movieDetails,
    arguments: id,
    );
  }
}