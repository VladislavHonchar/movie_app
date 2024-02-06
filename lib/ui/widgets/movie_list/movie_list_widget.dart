import 'package:flutter/material.dart';
import 'package:movie_app/domain/api_client/api_client.dart';
import 'package:movie_app/domain/library/widgets/inherited/provider.dart';
import 'package:movie_app/ui/widgets/movie_list/movie_list_model.dart';
import 'package:intl/intl.dart';


class MovieListWidget extends StatelessWidget {

  MovieListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieListModel>(context);
    if (model == null) return const SizedBox.shrink();
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 70),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: model.movies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index){
            final movie = model.movies[index];
            final posterPath = movie.posterPath;
            final releaseDate = movie.releaseDate;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Stack(
                children: [
                  Container(
                     decoration: BoxDecoration(
                      color: Colors.white,
                        border: Border.all(color: Colors.black.withOpacity(0.2)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2)
                          )
                        ]
                      ),
                      clipBehavior: Clip.hardEdge,
                    child: Row(
                      children: [
                        posterPath !=  null ?  Image.network(ApiClient.imageUrl(posterPath), width: 95) : const SizedBox.shrink(),//Image(image: AssetImage(movie.imageName)),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             const SizedBox(height: 20),
                              Text(movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                              const SizedBox(height: 5),
                              Text(
                                 model.stringFromDate(movie.releaseDate),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.grey
                              ),),
                              const SizedBox(height: 20),
                              Text(movie.overview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,),
                              
                          
                            ],
                          ),
                        ),
                        SizedBox(width: 10,)
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: () => model.onMovieTap(context, index),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search',
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}