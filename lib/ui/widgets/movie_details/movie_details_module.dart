import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/api_client/account_api_client.dart';
import 'package:movie_app/domain/api_client/movie_api_client.dart';
import 'package:movie_app/domain/api_client/api_client_exeption.dart';
import 'package:movie_app/domain/data_provider/session_data_provider.dart';
import 'package:movie_app/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier{
  final _sessionDataProvider = SessionDataProvider();
  final _movieApiClient = MovieApiClient();
  final _accountApiClient = AccountApiClient();
  
  final int movieId;
  String _locale = '';
  bool _isFavorite = false;
  MovieDetails? _movieDetails;
  late DateFormat _dateFormat;
  Future<void>? Function()? onSessionExpired;

  bool get isFavorite => _isFavorite;


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
    try{
    _movieDetails = await _movieApiClient.movieDetails(movieId, _locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    if(sessionId != null) {
    _isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
    }
    notifyListeners();
    } on ApiClientExeption catch(e){
      _handleApiClientExeption(e);
    }
  }

  Future<void> toggleFavorite() async{
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    if(accountId == null || sessionId == null) return;
    _isFavorite = !_isFavorite;
    try{
    await _accountApiClient.markAsFavorite(
      accountId: accountId, 
      sessionId: sessionId, 
      mediaType: MediaType.movie, 
      mediaId: movieId, 
      isFavorite: _isFavorite
      );
    notifyListeners();
    } on ApiClientExeption catch(e){
      _handleApiClientExeption(e);
    }
  }

  void _handleApiClientExeption(ApiClientExeption exeption) {
     switch(exeption.type){
        case ApiClientExeptionType.sessionExpired:
        onSessionExpired?.call();
        break;
        default:
        print(exeption);
      }
  }
}