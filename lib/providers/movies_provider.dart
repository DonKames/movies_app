import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '03cdff451185df29df8235e3bb576393';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  int _popularPage = 0;

  MoviesProvider() {
    print('MoviesProvider inicializado.');

    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    Uri url = Uri.https(_baseUrl, endpoint, {
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

    print(popularMovies[0]);
    notifyListeners();
  }
}
