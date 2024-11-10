import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String avatar;
  final String birthday;
  final int electricalSafetyGroup;
  final String email;
  final String name;
  final String patronymic;
  final String phoneNumber;
  final String position;
  final String role;
  final String supervisor;
  final String surname;
  final String username;
  final String workPlace;

  UserModel({
    required this.id,
    required this.avatar,
    required this.birthday,
    required this.electricalSafetyGroup,
    required this.email,
    required this.name,
    required this.patronymic,
    required this.phoneNumber,
    required this.position,
    required this.role,
    required this.supervisor,
    required this.surname,
    required this.username,
    required this.workPlace,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String,
      avatar: json['avatar'] as String,
      birthday: json['birthday'] as String,
      electricalSafetyGroup: json['electrical_safety_group'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      patronymic: json['patronymic'] as String,
      phoneNumber: json['phone_number'] as String,
      position: json['position'] as String,
      role: json['role'] as String,
      supervisor: json['supervisor'] as String,
      surname: json['surname'] as String,
      username: json['username'] as String,
      workPlace: json['work_place'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'avatar': avatar,
      'birthday': birthday,
      'electrical_safety_group': electricalSafetyGroup,
      'email': email,
      'name': name,
      'patronymic': patronymic,
      'phone_number': phoneNumber,
      'position': position,
      'role': role,
      'supervisor': supervisor,
      'surname': surname,
      'username': username,
      'work_place': workPlace,
    };
  }

  User toEntity() {
    return User(
      id: id,
      avatar: avatar,
      birthday: birthday.isNotEmpty ? DateTime.parse(birthday) : null,
      electricalSafetyGroup: electricalSafetyGroup,
      email: email,
      name: name,
      patronymic: patronymic,
      phoneNumber: phoneNumber,
      position: position,
      role: role,
      supervisor: supervisor,
      surname: surname,
      username: username,
      workPlace: workPlace,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      avatar: user.avatar,
      birthday: user.birthday?.toIso8601String() ?? '',
      electricalSafetyGroup: user.electricalSafetyGroup,
      email: user.email,
      name: user.name,
      patronymic: user.patronymic,
      phoneNumber: user.phoneNumber,
      position: user.position,
      role: user.role,
      supervisor: user.supervisor,
      surname: user.surname,
      username: user.username,
      workPlace: user.workPlace,
    );
  }
}