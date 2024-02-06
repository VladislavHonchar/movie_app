import 'package:flutter/material.dart';
import 'package:movie_app/elements/radial_percent_widget.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TopPostersWidget(),
        Padding(
          padding: const EdgeInsets.all(20.0),
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
        SizedBox(height: 30,),
        _PeopleWidget(),
        
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
    return Text(
        "За много лет до того, как стать тираническим президентом Панема, 18-летний Кориолан Сноу — последняя надежда своего угасающего рода, некогда гордой семьи, потерявшей благородство в послевоенном Капитолии. С приближением 10-х ежегодных Голодных игр молодой Сноу встревожен, когда его назначают наставником Люси Грей Бэрд, девушки-трибуна из бедного Дистрикта 12. Но после того, как Люси Грей привлекает внимание всего Панема, дерзко спев во время церемонии жатвы, Сноу думает, что сможет переломить ситуацию в свою пользу. Объединив свои инстинкты шоумена и политическую смекалку, Сноу и Люси Грей попадают в водоворот событий в борьбе за выживание. В конечном итоге они выяснят, кто из них певчая птица, а кто змея...",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),);
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
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
    return Stack(children: [
      Image(
        image: AssetImage("images/background.jpg"),
      ),
      Positioned(
        top: 20,
        left: 20,
        bottom: 20,
        child: Image(
          image: AssetImage("images/avatar.jpg"),
        ),
      ),
    ]);
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      textAlign: TextAlign.center,
      text: const TextSpan(children: [
        TextSpan(
            text: "Tom Clansy`s Without Remorse",
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600)),
        TextSpan(
            text: "(2021)",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
      ]),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: (){}, child: const Row(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: RadialPercentWidget(
                child: Text('72%', style: TextStyle(color: Colors.white),),
                percent: 0.72,
                fillColor: Color.fromARGB(255, 20, 23, 35),
                freeColor: Color.fromARGB(255, 25, 54, 31),
                lineColor: Color.fromARGB(255, 37, 203, 103),
                lineWidth: 3,
                ),
            ),
            SizedBox(width: 10,),
            Text("User Score", style: TextStyle(color: Colors.white),)
          ],
        )),
        Container(color: Colors.grey, width: 1, height: 15,),
        TextButton(onPressed: (){}, child: const Row(
          children: [
            Icon(Icons.play_arrow, color: Colors.white,),
            Text("Play Trailer", style: TextStyle(color: Colors.white),)
          ],
        )),

      ],
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
        child: Text(
          "R, 04/29/2021 (US) 1h 49m Action, Adventure, Thriller, War",
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
   _PeopleWidget({super.key});
  final nameStyle =TextStyle(
              color: Colors.white, 
              fontSize: 16, 
              fontWeight: FontWeight.w400);

  final jobTitleStyle = TextStyle(
              color: Colors.white, 
              fontSize: 16, fontWeight: 
              FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Stefano Sollima", style: nameStyle,),
                Text("Director", style: jobTitleStyle,),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Stefano Sollima", style: nameStyle,),
                Text("Director", style: jobTitleStyle,),
              ],
            )
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Stefano Sollima", style: nameStyle,),
                Text("Director", style: jobTitleStyle,),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Stefano Sollima", style: nameStyle,),
                Text("Director", style: jobTitleStyle,),
              ],
            )
          ],
        )
      ],
    );
  }
}
