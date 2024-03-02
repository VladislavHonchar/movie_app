import 'package:flutter/material.dart';
import 'package:movie_app/domain/api_client/image_downloader.dart';
import 'package:movie_app/elements/radial_percent_widget.dart';
import 'package:movie_app/ui/navigation/main_navigation.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_module.dart';
import 'package:provider/provider.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopPostersWidget(),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummeryWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
    final overview =
        context.select((MovieDetailsModel model) => model.data.overview);

    return Text(
      overview,
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
    final model = context.read<MovieDetailsModel>();
    final posterData =
        context.select((MovieDetailsModel model) => model.data.posterData);
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;
    // ApiClient.imageUrl(backdropPath);
    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(children: [
        if (backdropPath != null)
          Image.network(ImageDownloader.imageUrl(backdropPath)),
        if (posterPath != null)
          Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: Image.network(ImageDownloader.imageUrl(posterPath))),
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            onPressed: () => model.toggleFavorite(context),
            icon: Icon(posterData.favoriteIcon),
          ),
        )
      ]),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var data = context.select((MovieDetailsModel model) =>
        model.data.nameData);
    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: data.name,
              style:
                  const TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
          TextSpan(
              text: data.year,
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
    final scoreData =
        context.select((MovieDetailsModel model) => model.data.scoreData);
    final trailerKey = scoreData.trailerKey;
    
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
                    percent: scoreData.voteAverage / 100,
                    fillColor: const Color.fromARGB(255, 20, 23, 35),
                    freeColor: const Color.fromARGB(255, 25, 54, 31),
                    lineColor: const Color.fromARGB(255, 37, 203, 103),
                    lineWidth: 3,
                    child: Text(
                      "${scoreData.voteAverage.toStringAsFixed(0)}%",
                      style: const TextStyle(color: Colors.white),
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
        if(trailerKey != null)
             TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                    MainNavigationRouteName.movieTrailerWidget,
                    arguments: trailerKey),
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
                ))
      ],
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final summary =
        context.select((MovieDetailsModel model) => model.data.summary);
    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Text(
          summary,
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
  const _PeopleWidget({super.key});
  @override
  Widget build(BuildContext context) {
    var crew = context
        .select((MovieDetailsModel model) => model.data.peopleData);

    return Column(
        children: crew
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _PeopleWidgetRow(crew: e),
                ))
            .toList());
  }
}

class _PeopleWidgetRow extends StatelessWidget {
  final List<MovieDetailsPeopleData> crew;
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
  final MovieDetailsPeopleData crew;
  const _PeopleWidgetRowItem({super.key, required this.crew});

  @override
  Widget build(BuildContext context) {
    const _textStyle = TextStyle(
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
