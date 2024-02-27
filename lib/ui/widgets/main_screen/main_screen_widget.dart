import 'package:flutter/material.dart';
import 'package:movie_app/domain/factorys/screen_factory.dart';
import 'package:movie_app/ui/widgets/movie_list/movie_list_model.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final modelMovieList = MovieListViewModel();
  final _screenFactory = ScreenFactory();
  
  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TMDB"),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _screenFactory.makeNewsList(),
          _screenFactory.makeMovieList(),
          _screenFactory.makeTvShows(),
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


