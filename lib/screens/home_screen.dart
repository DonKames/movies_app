import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en Cines'),
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Tarjetas Principales
            CardSwiper(movies: moviesProvider.onDisplayMovies),

            //Slider de Películas
            MovieSlider(
                movies: moviesProvider.popularMovies, title: 'Populares'),
            MovieSlider(movies: moviesProvider.popularMovies),
            MovieSlider(movies: moviesProvider.popularMovies, title: 'Testing'),
          ],
        ),
      ),
    );
  }
}
