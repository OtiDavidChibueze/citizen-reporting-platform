import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.fullname,
    required super.email,
    required super.password,
  });

  UserModel copyWith({String? fullname, String? email, String? password}) {
    return UserModel(
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fullname': fullname,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      fullname: map['fullname'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  @override
  String toString() =>
      'UserModel(fullname: $fullname, email: $email, password: $password)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.fullname == fullname &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => fullname.hashCode ^ email.hashCode ^ password.hashCode;
}
