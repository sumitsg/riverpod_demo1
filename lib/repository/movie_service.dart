import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo1/envi_config.dart';
import 'package:riverpod_demo1/model/movie.dart';
import 'package:riverpod_demo1/pages/movies_exceptions.dart';

final movieServiceProvider = Provider<MovieService>((ref) {
  final config = ref.watch(environementconfigProvider);

  return MovieService(
    config,
    Dio(),
  );
});

class MovieService {
  final Environmentconfig _environmentconfig;
  final Dio _dio;

  MovieService(
    this._environmentconfig,
    this._dio,
  );

  final apiKey = '111f14ebbece0bf4b33f6322435e0d14';

  Future<List<Movie>> getMovies() async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1');
      print(response.statusCode);
      final result = List<Map<String, dynamic>>.from(response.data['results']);
      List<Movie> movies = result
          .map((movieData) => Movie.fromMap(movieData))
          .toList(growable: false);

      return movies;
    } on DioError catch (e) {
      throw MoviesException.fromDioError(e);
    }
  }
}
