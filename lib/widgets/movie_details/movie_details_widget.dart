import 'package:flutter/material.dart';
import 'package:movie_app/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:movie_app/widgets/movie_details/movie_details_screen_cast_widget.dart';

class MovieDetailWidget extends StatefulWidget {
  final int movieId;
  const MovieDetailWidget({super.key, required this.movieId});

  @override
  State<MovieDetailWidget> createState() => _MovieDetailWidgetState();
}

class _MovieDetailWidgetState extends State<MovieDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tom Clancy`s Without Remorse",
        style: TextStyle(color: Colors.white),),
      ),
      body: ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1),
        child: ListView(
          children: [
            MovieDetailsMainInfoWidget(),
            SizedBox(height: 30,),
            MovieDdetailsMainScreenCastWidget()
          ],
        ),
      ),
    );
  }
}