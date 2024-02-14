import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/data_provider/session_data_provider.dart';
import 'package:movie_app/domain/entity/movie_details.dart';

class MovieDetailsModel extends ChangeNotifier{
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();
  
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
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);
    final sessionId = await _sessionDataProvider.getSessionId();
    if(sessionId != null) {
    _isFavorite = await _apiClient.isFavorite(movieId, sessionId);
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
    await _apiClient.markAsFavorite(
      accountId: accountId, 
      sessionId: sessionId, 
      mediaType: MediaType.Movie, 
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
        case ApiClientExeptionType.SessionExpired:
        onSessionExpired?.call();
        break;
        default:
        print(exeption);
      }
  }
}