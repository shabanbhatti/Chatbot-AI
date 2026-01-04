import 'package:equatable/equatable.dart';

class CountriesEntity extends Equatable {
  final String country;
  final String flag;
  final String official;
  const CountriesEntity({required this.country, required this.official, required this.flag});

  @override
  List<Object?> get props => [country, official];
}