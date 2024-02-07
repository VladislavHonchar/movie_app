
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/domain/entity/popular_movie_response.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier{
  final _apiClient = ApiClient();
  final _movies = <Movie>[];
  late int _currentPage;
  late int _totalPage;
  var _isLoadingInProgress = false;
  String? _searchQuery;
  Timer? _searchDebounce;


  List<Movie> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  late String _locale = '';

  String stringFromDate(DateTime? date) => 
  date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async{
    final locale = Localizations.localeOf(context).toLanguageTag();
    if(_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _movies.clear();
    await _loadNextPage();
  }

  Future<PopularMovieResponse> _loadMovies(int nextPage, String locale) async{
    final query = _searchQuery;
    if(query == null) {
      return await _apiClient.popularMovie(nextPage, _locale);
    }else{
      return await _apiClient.searchMovie(nextPage, locale, query);
    }
  }

  Future<void> _loadNextPage() async{
    if(_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = true;
    final nextPage = _currentPage + 1;

    try{
    final moviesResponse = await _loadMovies(nextPage, _locale);
    _currentPage = moviesResponse.page;
    _totalPage = moviesResponse.totalPages;

    _movies.addAll(moviesResponse.movies);
    _isLoadingInProgress = false;
    notifyListeners();
    }catch (e){
    _isLoadingInProgress = false;
    }
  }

  Future<void> searchMovie(String text) async{
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(seconds: 1), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if(_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      await _resetList();
    });
    
  }


  void onMovieTap(BuildContext context, int index){
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(MainNavigationRouteName.movieDetails,
    arguments: id,
    );
  }

  void showMovieAtIndex(int index){
    if(index < _movies.length - 1) return;
    _loadNextPage();
  }
}