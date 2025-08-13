class RegisterDTO {
  final String name;
  final String email;
  final String password;

  RegisterDTO({
    required this.name,
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
