// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  String name;
  String email;
  String? phone;
  String? password;

  UserModel({
    required this.name,
    required this.email,
    this.phone,
    this.password,
  });
}
