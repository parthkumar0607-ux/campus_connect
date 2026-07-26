class UserModel {
  final int id;
  final String name;
  final String email;
  final String? college;
  final String? course;
  final String? year;
  final String? bio;
  final String? skills;
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
    };
  }
}