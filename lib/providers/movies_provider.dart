import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '03cdff451185df29df8235e3bb576393';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 350),
  );

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final Uri url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);

    //if (response.statusCode != 200) return print('error getNowPlayingMovies');

    return response.body;
  }

  getNowPlayingMovies() async {
    final response = _getJsonData('3/movie/now_playing', 1);

    final nowPlayingResponse = NowPlayingResponse.fromJson(await response);

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final response = await _getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(response);

    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    //TODO: revisar el Mapa

    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    print('pidiendo info al servidor - Cast');

    final response = await _getJsonData('3/movie/$movieId/credits');

    final creditResponse = CreditResponse.fromJson(response);

    movieCast[movieId] = creditResponse.cast;

    return creditResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final Uri url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    final response = await http.get(url);

    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      //print('Tenemos valor a buscar: $value')
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
