class UserModel {
  final int id;
  final String name;
  final String email;
  final String? college;
  final String? course;
  final String? year;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.college,
    this.course,
    this.year,
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
    );
  }
}