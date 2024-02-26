import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/config/configuration.dart';
import 'package:movie_app/domain/api_client/movie_api_client.dart';
import 'package:movie_app/domain/api_client/image_downloader.dart';
import 'package:movie_app/domain/entity/movie_details_casts.dart';
import 'package:movie_app/domain/library/widgets/inherited/provider.dart';
import 'package:movie_app/elements/radial_percent_widget.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_module.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TopPostersWidget(),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: _MovieNameWidget(),
        ),
        const _ScoreWidget(),
        const _SummeryWidget(),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _PeopleWidget(),
        ),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movieDetails =
        NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;

    return Text(
      movieDetails?.overview ?? '',
      style: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Overview",
      style: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}

class _TopPostersWidget extends StatelessWidget {
  const _TopPostersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    final posterPath = model?.movieDetails?.posterPath;
    // ApiClient.imageUrl(backdropPath);
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(children: [
        backdropPath != null
            ? Image.network(ImageDownloader.imageUrl(backdropPath))
            : const SizedBox.shrink(),
        Positioned(
          top: 20,
          left: 20,
          bottom: 20,
          child: posterPath != null
              ? Image.network(ImageDownloader.imageUrl(posterPath))
              : const SizedBox.shrink(),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            onPressed: () => model?.toggleFavorite(),
            icon: Icon(model?.isFavorite == true
            ? Icons.favorite
            : Icons.favorite_outline),)
          )
      ]
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: model?.movieDetails?.title ?? '',
              style:
                  const TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          TextSpan(
              text: year,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
        ]),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final movieDetails =
        NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;
    var voteAverage = movieDetails?.voteAverage ?? 0;
    voteAverage = voteAverage * 10;
    final videos = movieDetails?.videos.results.where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: RadialPercentWidget(
                    percent: voteAverage / 100,
                    fillColor: const Color.fromARGB(255, 20, 23, 35),
                    freeColor: const Color.fromARGB(255, 25, 54, 31),
                    lineColor: const Color.fromARGB(255, 37, 203, 103),
                    lineWidth: 3,
                    child: Text(
                      "${voteAverage.toStringAsFixed(0)}%",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "User Score",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )),
        Container(
          color: Colors.grey,
          width: 1,
          height: 15,
        ),
        trailerKey != null ? TextButton(
            onPressed: () => Navigator.of(context).pushNamed(
              MainNavigationRouteName.movieTrailerWidget, 
              arguments: trailerKey
              ),
            child: const Row(
              children: [
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                Text(
                  "Play Trailer",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          )
          : const SizedBox.shrink()
      ],
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    var texts = <String>[];
    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      texts.add(model.stringFromDate(releaseDate));
    }
    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      texts.add('(${productionCountries.first.iso})');
    }
    final runtime = model.movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');
    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genr in genres) {
        genresNames.add(genr.name);
      }
      texts.add(genresNames.join(', '));
    }
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          texts.join(' '),
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  _PeopleWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var crew = model?.movieDetails?.credits.crew;
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChanks = <List<Crew>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChanks
          .add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }

    return Column(
        children: crewChanks
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _PeopleWidgetRow(crew: e),
                ))
            .toList());
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<Crew> crew;
  const _PeopleWidgetRow({super.key, required this.crew});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: crew.map((e) => _PeopleWidgetRowItem(crew: e)).toList(),
    );
  }
}

class _PeopleWidgetRowItem extends StatelessWidget {
  final Crew crew;
  const _PeopleWidgetRowItem({super.key, required this.crew});

  @override
  Widget build(BuildContext context) {
    final _textStyle = const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            crew.name,
            style: _textStyle,
          ),
          Text(
            crew.job,
            style: _textStyle,
          ),
        ],
      ),
    );
  }
}
