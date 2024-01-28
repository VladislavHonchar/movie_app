import 'package:flutter/material.dart';

class Movie {
  final int id;
  final String imageName;
  final String title;
  final String time;
  final String description;

  Movie({
    required this.id,
    required this.imageName, 
    required this.title, 
    required this.time, required 
    this.description});
}


class MovieListWidget extends StatefulWidget {

  MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final _movies = [
    Movie(
      id: 1,
      imageName: "images/hancock.jpg", 
      title: "Shrek", 
      time: "May 9, 2001", 
      description: "Shrek, a grouchy, mean, selfish green ogre that has always enjoyed living in peaceful solitude in his swamp, finds his life disrupted when numerous fairytale beings."
    ),
    Movie(
      id: 2,
      imageName: "images/hancock.jpg", 
      title: "Close", 
      time: "May 23, 2022", 
      description: "Thirteen-year-olds Leo and Remi are inseparable; they spend every waking moment together, playing in the flower fields and sleeping at each other’s houses. However as they start a new school year, the pressures of early adolescence challenge their bond with unexpected and far-reaching consequences."
    ),
    Movie(
      id: 3,
      imageName: "images/hancock.jpg", 
      title: "My life as a Courgette", 
      time: "June 17, 2016", 
      description: "After his abusive mother’s sudden death, Courgette is befriended by police officer Raymond, who accompanies him to the orphanage. At first Courgette struggles to find his place in this strange environment. Yet with Raymond’s help and his new friends, he eventually learns to trust, and finds love."
    ),
    Movie(
      id: 4,
      imageName: "images/hancock.jpg", 
      title: "Drive my Car", 
      time: "June 12, 2021", 
      description: "Two years after his wife’s death, Yusuke Kafuku receives an offer to direct a play at a theater festival in Hiroshima. There, he meets Misaki, a reserved young woman assigned to be his chauffeur. As they spend time together, Kafuku starts to confront the mystery of his wife that quietly haunts him."
    ),
    Movie(
      id: 5,
      imageName: "images/hancock.jpg", 
      title: "Seven Samurai", 
      time: "December 30, 1954", 
      description: "A sixteenth century farming village requests protection from the seven samurai against a horde of bandits who have warned they will return when the crops are ripe. A gripping three hour ride that inspired the Hollywood remake, The Magnificent Seven."
    ),
    Movie(
      id: 6,
      imageName: "images/hancock.jpg", 
      title: "Paris, Texas", 
      time: "January 21, 1984", 
      description: "Travis walks out of the Texas desert after disappearing for four years. He is picked up by his brother Walt, who has been looking after Travis’ son Hunter. After slowly reconnecting with Hunter, Travis tries to bring his family back together by traveling to Houston in search of his estranged wife."
    ),
    Movie(
      id: 7,
      imageName: "images/hancock.jpg", 
      title: "Stalker", 
      time: "September 14, 1979", 
      description: "A hired guide leads his two clients—a writer looking for inspiration and a professor seeking scientific discovery—through a hazardous wasteland and into the heart of the Zone, the restricted site of a long-ago disaster. Within the Zone is the Room: a place rumored to fulfil one’s deepest desires."
    ),
    Movie(
      id: 8,
      imageName: "images/hancock.jpg", 
      title: "Persona", 
      time: "September 21, 1966", 
      description: "After Elisabet, a famed actress, lapses into silence from what appears to be a breakdown, she goes to a beach house with only Alma, a nurse, as company. Over the next weeks, as Alma struggles to reach her mute patient, they both find themselves experiencing a strange emotional convergence."
    ),
  ];

  var _filteredMovies = <Movie>[];

  final _searchController = TextEditingController();

  void _searchMovies() {
    final query = _searchController.text;
    if(query.isNotEmpty){
      _filteredMovies = _movies.where((Movie movie){
        return movie.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }else {
      _filteredMovies = _movies;
    }
    setState(() {
      
    });
  }

  void _onMovieTap(int index){
    final id =_movies[index].id;
    Navigator.of(context).pushNamed('/main_screen/movie_details', arguments: id);
  }


  @override
  void initState() {
    super.initState();
    _filteredMovies = _movies;
    _searchController.addListener(_searchMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.only(top: 70),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: _filteredMovies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index){
            final movie = _filteredMovies[index];
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
                        Image(image: AssetImage(movie.imageName)),
                        SizedBox(width: 15,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(movie.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                              SizedBox(height: 5),
                              Text(movie.time,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey
                              ),),
                              SizedBox(height: 20),
                              Text(movie.description,
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
                      onTap: () => _onMovieTap(index),
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
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              filled: true,
              fillColor: Colors.white.withAlpha(235),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}