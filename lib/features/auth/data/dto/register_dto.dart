class RegisterDTO {
  final String fullname;
  final String email;
  final String password;

  RegisterDTO({
    required this.fullname,
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullname': fullname,
      'email': email,
      'password': password,
    };
  }
}
