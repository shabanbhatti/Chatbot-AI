class UserEntity {
  final int? id;
  final String name;
  final String dateOfBirth;
  final String gender;
  final String country;
  final String userImg;

  const UserEntity({
    this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.country,
    required this.userImg,
  });
}
