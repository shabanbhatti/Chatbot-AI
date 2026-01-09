import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
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
  UserEntity copyWith({
    String? name,
    String? dateOfBirth,
    String? gender,
    String? country,
    String? userImg,
    int? id,
  }) {
    return UserEntity(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      userImg: userImg ?? this.userImg,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [name, dateOfBirth, gender, country, userImg, id];
}
