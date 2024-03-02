import 'package:flutter/material.dart';
import 'package:movie_app/config/configuration.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_module.dart';
import 'package:provider/provider.dart';

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
        const Scrollbar(
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
    var data = context.select((MovieDetailsModel model) => model.data.actorData);
    if(data.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      itemCount: data.length,
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
    final model = context.read<MovieDetailsModel>();
    final actor = model.data.actorData[actorIndex];
    final profilePath = actor.profilePath;
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
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if(profilePath != null) 
                   Image.network('$_imageURL$profilePath'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        actor.name,
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
