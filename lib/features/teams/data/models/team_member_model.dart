class TeamMemberModel {
  final int id;
  final String name;

  TeamMemberModel({
    required this.id,
    required this.name,
  });

  factory TeamMemberModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeamMemberModel(
      id: json["id"],
      name: json["name"],
    );
  }
}