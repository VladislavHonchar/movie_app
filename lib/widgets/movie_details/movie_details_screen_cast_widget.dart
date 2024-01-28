import 'package:flutter/material.dart';

class MovieDdetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDdetailsMainScreenCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Series Cast",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
        Scrollbar(
          child: SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: 20,
              itemExtent: 120,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.black.withOpacity(0.2)),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2))
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        clipBehavior: Clip.hardEdge,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image(image: AssetImage('images/actor.jpg')),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stiven Mail",
                                    maxLines: 1,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    "Mark Grayson / Invicible (voice),",
                                    maxLines: 4,
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text("8 episodes",
                                  maxLines: 1,),
                                  SizedBox(
                                    height: 7,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextButton(onPressed: () {}, child: Text("Full Cast & Crew")),
        ),
      ]),
    );
  }
}
