import 'package:flutter/material.dart';
import '/users/screens/profile_screen.dart';
import '/users/screens/theatres_screen.dart';
import 'package:provider/provider.dart';

import '/shared/loader.dart';
import '../../../constants/color.dart';
import '../../providers/movie_provider.dart';
import '../widgets/header.dart';
import '../widgets/movie/movie_cards.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<UserHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    final screens = [
      _buildMoviesScreen(movieProvider),
      const TheatresScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _currentIndex == 0 ? Header() : null,
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.theaters),
            label: 'Theatres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesScreen(MovieProvider movieProvider) {
    if (movieProvider.loading) {
      return const Center(
        child: Loader(content: "Movies are being loaded"),
      );
    }

    if (movieProvider.movies.isEmpty) {
      return const Center(
        child: Text("No movies available"),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.53,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
      ),
      itemCount: movieProvider.movies.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: movieProvider.movies[index]);
      },
    );
  }
}