import 'package:chatbot_ai/shared/domain/entity/country_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object?> get props => [];
}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  final List<CountriesEntity> allCountries;
  final List<CountriesEntity> filteredCountries;

  const CountriesLoaded({
    required this.allCountries,
    required this.filteredCountries,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [allCountries, filteredCountries];
}

class CountriesError extends CountriesState {
  final String message;
  const CountriesError({required this.message});
}
