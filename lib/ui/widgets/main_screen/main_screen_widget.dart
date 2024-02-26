import 'package:flutter/material.dart';
import 'package:movie_app/domain/library/widgets/inherited/provider.dart';
import 'package:movie_app/ui/widgets/main_screen/main_screen_model.dart';
import 'package:movie_app/ui/widgets/movie_list/movie_list_model.dart';
import 'package:movie_app/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:provider/provider.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final modelMovieList = MovieListModel();
  
  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    modelMovieList.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TMDB"),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
         ChangeNotifierProvider(
          create: (_) => MainScreenModel(),
          lazy: false,
           child: const _LogOutButton()
         ),
          NotifierProvider(
            create: () => modelMovieList,
            isManagingModel: false,
            child: MovieListWidget()),
          Text("Index 2: TV Shows"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "News",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movie"),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "TV Shows")
        ],
        onTap: onSelectTab,
      ),
    );
  }
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton({super.key});

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
