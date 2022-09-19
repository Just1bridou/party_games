class Player {
  String id;
  String name;
  String code;
  bool admin;
  String avatar;

  Player(
      {required this.name,
      required this.code,
      required this.admin,
      required this.id,
      required this.avatar});

  equals(Player player) {
    return id == player.id;
  }

  factory Player.fromJson(Map<String, dynamic> json) => Player(
      id: json["id"],
      name: json["name"],
      code: json["code"],
      admin: json["admin"],
      avatar: json["avatar"]);

  Map toJson() {
    return {
      "id": id,
      "name": name,
      "code": code,
      "admin": admin,
      "avatar": avatar
    };
  }
}
