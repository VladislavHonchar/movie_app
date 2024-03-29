import 'package:movie_app/config/configuration.dart';
import 'package:movie_app/domain/api_client/account_api_client.dart';
import 'package:movie_app/domain/api_client/movie_api_client.dart';
import 'package:movie_app/domain/data_provider/session_data_provider.dart';
import 'package:movie_app/domain/entity/popular_movie_response.dart';
import 'package:movie_app/domain/local_entity/movie_details_local.dart';

class MovieService{
  final _movieApiClient = MovieApiClient();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale) => 
  _movieApiClient.popularMovie(page, locale, Configuration.apiKey);
  

  Future<PopularMovieResponse> searchMovie(
    int page,
    String locale,
    String query,
  ) async => 
    _movieApiClient.searchMovie(page, locale, query, Configuration.apiKey);

    Future<MovieDetailsLocal> loadDetails({
      required int movieId, 
      required String locale
      }) async {
      final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
      final sessionId = await _sessionDataProvider.getSessionId();
      var isFavorite = false;
      if (sessionId != null) {
        isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
      }
      return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite);
    }

    Future<void> updateFavorite({required int movieId ,required bool isFavorite}) async {
    final accountId = await _sessionDataProvider.getAccountId();
    final sessionId = await _sessionDataProvider.getSessionId();
    if (accountId == null || sessionId == null) return;
    await _accountApiClient.markAsFavorite(
      accountId: accountId, 
      sessionId: sessionId, 
      mediaType: MediaType.movie, 
      mediaId: movieId, 
      isFavorite: isFavorite
      );
  }
}