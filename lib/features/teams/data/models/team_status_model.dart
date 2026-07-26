class TeamStatusModel {
  final bool joined;
  final bool isCreator;

  TeamStatusModel({
    required this.joined,
    required this.isCreator,
  });

  factory TeamStatusModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeamStatusModel(
      joined: json["joined"],
      isCreator: json["is_creator"],
    );
  }
}