import 'package:flutter/material.dart';
import 'package:riverpod_demo1/model/movie.dart';

class Details extends StatelessWidget {
  final Movie movie;
  const Details({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 250,
              height: 300,
              child: Image.network(movie.fullImageUrl),
            ),
            Text(
              movie.title,
              style: const TextStyle(fontSize: 20),
            ),
            const Divider(
              thickness: 1,
            ),
            const Text('Overview '),
            const Divider(
              thickness: 2,
            ),
            Text(
              movie.overview,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
