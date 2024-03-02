import 'package:flutter/material.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_module.dart';
import 'package:movie_app/ui/widgets/movie_details/movie_details_screen_cast_widget.dart';
import 'package:provider/provider.dart';


class MovieDetailWidget extends StatefulWidget {
  const MovieDetailWidget({super.key});

  @override
  State<MovieDetailWidget> createState() => _MovieDetailWidgetState();
}

class _MovieDetailWidgetState extends State<MovieDetailWidget> {
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    Future.microtask(() => 
    context.read<MovieDetailsModel>().setupLocale(context, locale)
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title:  const _TitleWidget()
      ),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1),
        child:  _BodyWidget(),
      ),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
     final isLoading = context.select((MovieDetailsModel model) => model.data.isLoading);
     if(isLoading){
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
    final title = context.select((MovieDetailsModel model) => model.data.title);
    return Text(title,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: Colors.white,
    ),);
  }
}