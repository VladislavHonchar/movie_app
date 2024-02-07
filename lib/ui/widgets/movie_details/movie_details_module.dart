import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier{
  final _apiClient = ApiClient();
  
  final int movieId;
  String _locale = '';
  MovieDetails? _movieDetails;
  late DateFormat _dateFormat;


  MovieDetails? get movieDetails => _movieDetails;

  MovieDetailsModel({required this.movieId});

  String stringFromDate(DateTime? date) => 
  date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async{
    final locale = Localizations.localeOf(context).toLanguageTag();
    if(_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await loadDetails();
  }

  Future<void> loadDetails() async {
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    notifyListeners();
  }
}