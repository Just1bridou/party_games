class Joke {
  int id;
  String type;
  String joke;
  String answer;

  Joke(
    this.id,
    this.type,
    this.joke,
    this.answer,
  );

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(json["id"], json["type"], json["joke"], json["answer"]);
  }
}
