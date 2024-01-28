import 'package:flutter/material.dart';
import 'package:movie_app/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  
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
        title: Text("TMDB"),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          Text("Index 0: News"),
          MovieListWidget(),
          Text("Index 2: TV Shows"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
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
