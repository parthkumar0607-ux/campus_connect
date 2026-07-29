class DiscoverUser {
  final int id;
  final String name;
  final String email;
  final String? college;
  final String? course;
  final String? year;
  final String? bio;
  final String? skills;
  final String? profileImage;

  DiscoverUser({
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

  factory DiscoverUser.fromJson(Map<String, dynamic> json) {
    return DiscoverUser(
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
}