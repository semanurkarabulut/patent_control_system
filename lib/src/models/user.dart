class User {
  String firstName;
  String secondName;
  String job;
  String email;
  String password;

  User({
    required this.email,
    required this.firstName,
    required this.job,
    required this.password,
    required this.secondName,
  });

  User.fromJson(Map<String, dynamic> json)
      : firstName = json["firstName"],
        secondName = json["secondName"],
        job = json["job"],
        email = json["email"],
        password = json["password"];

  Map<String, dynamic>? toJson() => {
        "firstName": firstName,
        "secondName": secondName,
        "jon": job,
        "email": email,
        "password": password
      };
}
