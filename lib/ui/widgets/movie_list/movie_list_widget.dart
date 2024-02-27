import 'package:flutter/material.dart';
import 'package:movie_app/config/configuration.dart';
import 'package:movie_app/ui/widgets/movie_list/movie_list_model.dart';
import 'package:provider/provider.dart';


class MovieListWidget extends StatefulWidget {

  MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<MovieListViewModel>().setupLocale(context);
  }
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        _MovieListWidget(),
        _SearchWidget(),
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListViewModel>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: model.searchMovie,
        decoration: InputDecoration(
          labelText: 'Search',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieListViewModel>();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 70),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: model.movies.length,
      itemExtent: 163,
      itemBuilder: (BuildContext context, int index){
        model.showMovieAtIndex(index);
        return _MovieListRowWidget(index: index);
      },
    );
  }
}

class _MovieListRowWidget extends StatelessWidget {
  final int index;
  const _MovieListRowWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListViewModel>();
    final movie = model.movies[index];
        final posterPath = movie.posterPath;
        const _imageURL = Configuration.imageUrl;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Stack(
            children: [
              Container(
                 decoration: BoxDecoration(
                  color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2)
                      )
                    ]
                  ),
                  clipBehavior: Clip.hardEdge,
                child: Row(
                  children: [
                    if(posterPath != null)
                      Image.network('$_imageURL$posterPath', width: 95),
                    
                    //Image(image: AssetImage(movie.imageName)),
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
                             movie.releaseDate,
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
                    const SizedBox(width: 10,)
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: () => model.onMovieTap(context, index),
                ),
              )
            ],
          ),
        );
  }
}