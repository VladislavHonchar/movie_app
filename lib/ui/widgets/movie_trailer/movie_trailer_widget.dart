import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieTrailerWidget extends StatefulWidget {
  final String youtubeKey;
  const MovieTrailerWidget({super.key, required this.youtubeKey});

  @override
  State<MovieTrailerWidget> createState() => _MovieTrailerWidgetState();
}

class _MovieTrailerWidgetState extends State<MovieTrailerWidget> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeKey,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  YoutubePlayerBuilder(
        //onExitFullScreen: () => Navigator.of(context).pop(),
          player: YoutubePlayer(
            controller: _controller,
          ),
          builder: (context, player) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
              child: player,
            ),
            );
          }
    );
  }
}
