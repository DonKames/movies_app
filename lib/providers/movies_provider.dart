import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  MoviesProvider() {
    print('MoviesProvider inicializado.');

    getNowPlayingMovies();
  }

  getNowPlayingMovies() async {
    String _baseUrl = 'api.themoviedb.org';
    String _apiKey = '03cdff451185df29df8235e3bb576393';
    String _language = 'es-ES';
    Uri url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

    final response = await http.get(url);

    if (response.statusCode != 200) return print('error getNowPlayinMoviss');

    final Map<String, dynamic> decodedData = json.decode(response.body);

    print(decodedData);
  }
}
