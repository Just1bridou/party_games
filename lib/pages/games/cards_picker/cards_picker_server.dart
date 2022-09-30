import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:projet_flutter_mds/server/ws.dart';

class CardsPickerServer {
  Config conf = Config();

  Future<String> getCard(String id) async {
    String url = "http://${conf.expressIP}:${conf.expressPort}/cards/";

    print("------------------");
    print("------------------");
    print("------------------");
    print(url);
    final response = await http.get(Uri.parse(url + id));
    print(response.body);
    var decodeResponse = jsonDecode(response.body);
    print(decodeResponse);
    return decodeResponse;
  }
}
