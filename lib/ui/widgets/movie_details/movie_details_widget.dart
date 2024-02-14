import 'package:flutter/material.dart';
import 'package:movie_app/domain/library/widgets/inherited/provider.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_module.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_screen_cast_widget.dart';
import 'package:movie_app/ui/widgets/my_app/my_app_module.dart';

class MovieDetailWidget extends StatefulWidget {
  const MovieDetailWidget({super.key});

  @override
  State<MovieDetailWidget> createState() => _MovieDetailWidgetState();
}

class _MovieDetailWidgetState extends State<MovieDetailWidget> {
  

  @override
  void initState() {
    super.initState();
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    final appModel = Provider.read<MyAppModel>(context);
    model?.onSessionExpired = () => appModel?.resetSession(context);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotifierProvider.read<MovieDetailsModel>(context)?.setupLocale(context);
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  const _TitleWidget()
      ),
      body: const ColoredBox(
        color: const Color.fromRGBO(24, 23, 27, 1),
        child:  _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
     final model = NotifierProvider.watch<MovieDetailsModel>(context);
     final movieDetails = model?.movieDetails;
     if(movieDetails == null){
      return const  Center(
        child: CircularProgressIndicator());
     }
    return ListView(
          children: const [
            MovieDetailsMainInfoWidget(),
            SizedBox(height: 30,),
            MovieDdetailsMainScreenCastWidget()
          ],
        );
  }
}

class _TitleWidget extends StatelessWidget {
 const _TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    return Text(model?.movieDetails?.title ?? "Завантаження...",
    textAlign: TextAlign.center,
    style: TextStyle(
      color: Colors.white,
    ),);
  }
}