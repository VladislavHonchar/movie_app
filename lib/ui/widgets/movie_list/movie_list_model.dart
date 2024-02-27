
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/entity/movie.dart';
import 'package:movie_app/domain/library/paginator.dart';
import 'package:movie_app/domain/services/movie_service.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';

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

class MovieListViewModel extends ChangeNotifier{
  final _movieService = MovieService();
  late final Paginator<Movie> _popularMoviePaginator ;
  late final Paginator<Movie> _searchMoviePaginator ;
  Timer? _searchDebounce;
  late String _locale = '';

  var _movies = <MovieListRowData>[];
  String? _searchQuery;


  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;

  String stringFromDate(DateTime? date) => 
  date != null ? _dateFormat.format(date) : '';

  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  MovieListViewModel(){
    _popularMoviePaginator = Paginator((page) async{
      final result = await _movieService.popularMovie(page, _locale);
      return PaginatorLoadResult(
        data: result.movies, 
        currentPage: result.page, 
        totalPage: result.totalPages
        );
    });
    _searchMoviePaginator = Paginator((page) async{
      final result = await _movieService.searchMovie(page, _locale, _searchQuery ?? '');
      return PaginatorLoadResult(
        data: result.movies, 
        currentPage: result.page, 
        totalPage: result.totalPages
        );
    });
  }

  Future<void> setupLocale(BuildContext context) async{
    final locale = Localizations.localeOf(context).toLanguageTag();
    if(_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  

  Future<void> _loadNextPage() async{
    if (isSearchMode){
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map(_makeRowData).toList();
    }else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
   
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

  Future<void> searchMovie(String text) async{
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(seconds: 1), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if(_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if(isSearchMode){
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
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