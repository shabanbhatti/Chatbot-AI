import 'package:chatbot_ai/core/shared%20domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? id;
  final String name;
  final String dateOfBirth;
  final String gender;
  final String country;
  final String? userImg;

  const UserModel({
    this.id,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.country,
    this.userImg,
  });

  static const String tableName = 'users';
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colDateOfBirth = 'age';
  static const String colGender = 'gender';
  static const String colCountry = 'country';
  static const String colUserImg = 'user_img';

  static const String createTableQuery =
      '''
  CREATE TABLE $tableName (
    $colId INTEGER,
    $colName TEXT NOT NULL,
    $colDateOfBirth TEXT NOT NULL,
    $colGender TEXT NOT NULL,
    $colCountry TEXT NOT NULL,
    $colUserImg TEXT NOT NULL
  )
  ''';

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map[colId],
      name: map[colName] ?? '',
      dateOfBirth: map[colDateOfBirth] ?? '',
      gender: map[colGender] ?? '',
      country: map[colCountry] ?? '',
      userImg: map[colUserImg] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      colId: id,
      colName: name,
      colDateOfBirth: dateOfBirth,
      colGender: gender,
      colCountry: country,
      colUserImg: userImg ?? '',
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      country: country,
      userImg: userImg ?? '',
      id: id,
    );
  }

  @override
  List<Object?> get props => [name, dateOfBirth, gender, country, userImg, id];
}
