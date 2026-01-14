import 'package:equatable/equatable.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();
  @override
  List<Object?> get props => [];
}

class GetCountriesEvent extends CountriesEvent {
  const GetCountriesEvent();
  @override
  List<Object?> get props => [];
}

class OnChangedCountriesEvent extends CountriesEvent {
  final String query;
  const OnChangedCountriesEvent({required this.query});
  @override
  List<Object?> get props => [query];
}
