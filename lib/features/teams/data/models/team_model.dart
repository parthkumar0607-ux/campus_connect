class TeamModel {
  final int id;
  final String title;
  final String description;
  final String techStack;
  final int maxMembers;
  final int currentMembers;
  final int createdBy;
  final DateTime createdAt;

  TeamModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    required this.maxMembers,
    required this.currentMembers,
    required this.createdBy,
    required this.createdAt,
  });

  factory TeamModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeamModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      techStack: json["tech_stack"],
      maxMembers: json["max_members"],
      currentMembers: json["current_members"],
      createdBy: json["created_by"],
      createdAt: DateTime.parse(
        json["created_at"],
      ),
    );
  }
}