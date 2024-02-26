import 'package:flutter/material.dart';
import 'package:movie_app/config/configuration.dart';
import 'package:movie_app/domain/api_client/movie_api_client.dart';
import 'package:movie_app/domain/library/widgets/inherited/provider.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_module.dart';

class MovieDdetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDdetailsMainScreenCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Series Cast",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Scrollbar(
          child: SizedBox(
            height: 240,
            child: _ActorListWidget(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextButton(onPressed: () {}, child: const Text("Full Cast & Crew")),
        ),
      ]),
    );
  }
}

class _ActorListWidget extends StatelessWidget {
  const _ActorListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    var cast = model?.movieDetails?.credits.cast;
    if (cast == null || cast.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      itemCount: 20,
      itemExtent: 120,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _ActorListItemWidget(actorIndex: index,);
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  final int actorIndex;
  const _ActorListItemWidget({
    super.key,
    required this.actorIndex
  });

  @override
  Widget build(BuildContext context) {
    const _imageURL = Configuration.imageUrl;
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    final actor = model?.movieDetails?.credits.cast[actorIndex];
    final profilePath = actor?.profilePath;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  profilePath != null 
                  ? Image.network('$_imageURL$profilePath')
                  : const SizedBox.shrink(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actor!.name,
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        actor.character,
                        maxLines: 2,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
