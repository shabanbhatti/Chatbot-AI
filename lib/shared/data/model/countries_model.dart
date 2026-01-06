
import 'package:chatbot_ai/shared/domain/entity/country_entity.dart';
import 'package:equatable/equatable.dart';

class CountriesModel extends Equatable {
  final String country;
  final String flag;
  final String official;
  const CountriesModel({
    required this.country,
    required this.official,
    required this.flag,
  });

  factory CountriesModel.fromMap(Map<String, dynamic> map) {
    return CountriesModel(
      country: map['country'] ?? '',
      official: map['offical'] ?? '',
      flag: map['flag'] ?? '',
    );
  }

  CountriesEntity toEntity() {
    return CountriesEntity(country: country, official: official, flag: flag);
  }

  @override
  List<Object?> get props => [country, official];
}
