import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/domain/api_client/api_client_exeption.dart';
import 'package:movie_app/domain/entity/movie_details.dart';
import 'package:movie_app/domain/library/widgets/localable_widget/localalized_model.dart';
import 'package:movie_app/domain/services/auth_service.dart';
import 'package:movie_app/domain/services/movie_service.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';

class MovieDetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;
  IconData get favoriteIcon => isFavorite ? Icons.favorite : Icons.favorite_outline;
  MovieDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false
  });
  

  MovieDetailsPosterData copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
  }) {
    return MovieDetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsMovieNameData {
  final String name;
  final String year;
  MovieDetailsMovieNameData({
    required this.name,
    required this.year,
  });
}

class MovieDetailsScoreData {
  final String? trailerKey;
  final double voteAverage;
  MovieDetailsScoreData({
    this.trailerKey,
    required this.voteAverage,
  });
}

class MovieDetailsActorData {
  final String name;
  final String character;
  final String? profilePath;
  MovieDetailsActorData({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class MovieDetailsPeopleData {
  final String name;
  final String job;
  MovieDetailsPeopleData({
    required this.name,
    required this.job,
  });
}

class MovieDetailsData {
  String title = 'Download...';
  bool isLoading = true;
  String overview = '';
  MovieDetailsPosterData posterData = MovieDetailsPosterData();
  MovieDetailsMovieNameData nameData =
      MovieDetailsMovieNameData(name: '', year: '');
  MovieDetailsScoreData scoreData = MovieDetailsScoreData(voteAverage: 0.0);
  String summary = '';
  List<List<MovieDetailsPeopleData>> peopleData =
      const <List<MovieDetailsPeopleData>>[];
  List<MovieDetailsActorData> actorData = const <MovieDetailsActorData>[];
}

class MovieDetailsModel extends ChangeNotifier {
  final _authService = AuthService();
  final _movieService = MovieService();

  final int movieId;
  final data = MovieDetailsData();
  final _localeStorage = LocalizedModelStorage();
  late DateFormat _dateFormat;

  MovieDetailsModel({required this.movieId});

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    if(!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(locale.toLanguageTag());
    updateData(null, false);
    await loadDetails(context);
  }

  

  void updateData(MovieDetails? details, bool isFavorite) {
    data.title = details?.title ?? 'Download...';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    data.posterData = MovieDetailsPosterData(
        backdropPath: details.backdropPath,
        posterPath: details.posterPath,
        isFavorite: isFavorite);
    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.nameData = MovieDetailsMovieNameData(name: details.title, year: year);
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    data.scoreData = MovieDetailsScoreData(
        voteAverage: details.voteAverage * 10, trailerKey: trailerKey);
    data.summary = makeSummary(details);
    data.peopleData = makePeopleData(details);
    data.actorData = details.credits.cast
        .map((e) => MovieDetailsActorData(
            name: e.name, character: e.character, profilePath: e.profilePath))
        .toList();
    notifyListeners();
  }

  String makeSummary(MovieDetails details) {
    var texts = <String>[];
    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }
    if (details.productionCountries.isNotEmpty) {
      texts.add('(${details.productionCountries.first.iso})');
    }
    final runtime = details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    if (details.genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in details.genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }
    return texts.join(', ');
  }

  List<List<MovieDetailsPeopleData>> makePeopleData(MovieDetails details) {
    var crew = details.credits.crew
        .map((e) => MovieDetailsPeopleData(name: e.name, job: e.job))
        .toList();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChanks = <List<MovieDetailsPeopleData>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChanks
          .add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }
    return crewChanks;
  }
  Future<void> loadDetails(BuildContext context) async {
    try {
      final details = await _movieService.loadDetails(movieId: movieId, locale: _localeStorage.localTag);
      updateData(details.details, details.isFavorite);
    } on ApiClientExeption catch (e) {
      if (context.mounted) {
        _handleApiClientExeption(e, context);
      }
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    data.posterData = data.posterData.copyWith(isFavorite: !data.posterData.isFavorite);
    try {
      await _movieService.updateFavorite(
        movieId: movieId, isFavorite: 
        data.posterData.isFavorite
        );
      notifyListeners();
    } on ApiClientExeption catch (e) {
      if (context.mounted) {
        _handleApiClientExeption(e, context);
      }
    }
  }

  void _handleApiClientExeption(
      ApiClientExeption exeption, BuildContext context) {
    switch (exeption.type) {
      case ApiClientExeptionType.sessionExpired:
        _authService.logOutUser();
        MainNavigation.resetNavigation(context);
        break;
      default:
    }
  }
}
