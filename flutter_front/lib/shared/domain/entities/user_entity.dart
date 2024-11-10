class User {
  final String id;
  final String avatar;
  final DateTime? birthday;
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

  User({
    required this.id,
    required this.avatar,
    this.birthday,
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

  String get fullName => '$surname $name $patronymic'.trim();

  bool isAdmin() => role.toLowerCase() == 'admin';

  bool hasElectricalSafetyGroup() => electricalSafetyGroup > 0;
}