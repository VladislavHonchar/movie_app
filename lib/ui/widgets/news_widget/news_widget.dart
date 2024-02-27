import 'package:flutter/material.dart';
import 'package:movie_app/ui/widgets/main_screen/main_screen_model.dart';
import 'package:provider/provider.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MainScreenModel>();
    return Column(
             children: [
              ElevatedButton(
                onPressed:()=> model.makeLogOutOnPressButton(context), 
                child: const Text('Logout')),
               const Text("Index 0: News"),
             ],
           );
  }
}
