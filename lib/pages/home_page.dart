import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_demo1/model/movie.dart';
import 'package:riverpod_demo1/pages/details.dart';
import 'package:riverpod_demo1/pages/movies_exceptions.dart';
import 'package:riverpod_demo1/repository/movie_service.dart';

final moviesFutureProvider =
    FutureProvider.autoDispose<List<Movie>>((ref) async {
  ref.maintainState = true;
  final movieService = ref.watch(movieServiceProvider);
  final movies = await movieService.getMovies();

  return movies;
});

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watch = ref.watch(moviesFutureProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Movies API '),
      ),
      body: watch.when(
        data: (movies) {
          return RefreshIndicator(
            onRefresh: () {
              return ref.refresh(movieServiceProvider).getMovies();
            },
            child: GridView.extent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
              children: movies.map((e) => _MovieBox(movie: e)).toList(),
            ),
          );
        },
        error: (e, s) {
          if (e is MoviesException) {
            return _ErrorBody(message: e.message);
          }
          return _ErrorBody(message: 'Oops, Something unexpected happerd');
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _ErrorBody extends ConsumerWidget {
  final String? message;
  const _ErrorBody({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message!),
          ElevatedButton(
              onPressed: () {
                ref.refresh(movieServiceProvider).getMovies();
              },
              child: const Text('Try Again'))
        ],
      ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  final Movie movie;
  const _MovieBox({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Details(movie: movie)));
      },
      child: Stack(
        children: [
          Image.network(
            movie.fullImageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _FrontBanner(text: movie.title),
          ),
        ],
      ),
    );
  }
}

class _FrontBanner extends StatelessWidget {
  final String text;
  const _FrontBanner({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 60,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
