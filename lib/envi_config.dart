import 'package:flutter_riverpod/flutter_riverpod.dart';

class Environmentconfig {
  final moviApiKey = const String.fromEnvironment("movieApiKey");
}

final environementconfigProvider = Provider<Environmentconfig>((ref) {
  return Environmentconfig();
});
