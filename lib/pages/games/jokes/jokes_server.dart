import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:projet_flutter_mds/models/joke.dart';

class JokesServer {
  String API_KEY = "1d77BmxyP7CIN-itrl8HEYC7fQUiSOaJ2m11C1Ry_ZU";
  String baseURL = "https://www.blagues-api.fr/";

  Future<Joke> getRandomJoke(bool dark) async {
    String disbaled = "";
    if (!dark) {
      disbaled = "?disallow=dark";
    }

    final response = await http.get(
        Uri.parse(baseURL + "api/random" + disbaled),
        headers: {"Authorization": "Bearer " + dotenv.env['JOKES_API_KEY']!});

    var decodeResponse = jsonDecode(response.body);

    return Joke.fromJson(decodeResponse);
  }
}
