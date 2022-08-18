import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '03cdff451185df29df8235e3bb576393';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  MoviesProvider() {
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
}
