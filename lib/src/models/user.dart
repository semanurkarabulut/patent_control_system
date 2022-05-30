class User {
  String firstName;
  String secondName;
  String email;
  String password;

  User({
    required this.email,
    required this.firstName,
    required this.password,
    required this.secondName,
  });

  User.fromJson(Map<String, dynamic> json)
      : firstName = json["firstName"],
        secondName = json["secondName"],
        email = json["email"],
        password = json["password"];

  Map<String, dynamic>? toJson() => {
        "firstName": firstName,
        "secondName": secondName,
        "email": email,
        "password": password
      };
}
