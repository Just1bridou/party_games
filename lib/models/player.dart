class Player {
  //String id;
  String name;
  String code;
  bool admin;
  String avatar;

  Player(
      {required this.name,
      required this.code,
      required this.admin,
      /* this.id, */ required this.avatar});

  factory Player.fromJson(Map<String, dynamic> json) => Player(
      name: json["name"],
      code: json["code"],
      admin: json["admin"],
      avatar: json["avatar"]);
}
