class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String? college;
  final String? course;
  final String? year;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    this.college,
    this.course,
    this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "college": college,
      "course": course,
      "year": year,
    };
  }
}