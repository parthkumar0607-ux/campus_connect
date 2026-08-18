class UserModel {
  final int id;
  final String name;
  final String email;
  final String? college;
  final String? course;
  final String? year;
  final String? bio;
  final String? skills;
  final List<String>? currentlyLearning;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.college,
    this.course,
    this.year,
    this.bio,
    this.skills,
    this.profileImage,
    this.currentlyLearning,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      college: json["college"],
      course: json["course"],
      year: json["year"],
      bio: json["bio"],
      skills: json["skills"],
      profileImage: json["profile_image"],
      currentlyLearning: (json["currently_learning"] as String?)?.split(RegExp(r'[;,\n]+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "college": college,
      "course": course,
      "year": year,
      "bio": bio,
      "skills": skills,
      "currently_learning": (currentlyLearning ?? []).join(', '),
    };
  }
}