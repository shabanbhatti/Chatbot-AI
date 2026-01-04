import 'package:equatable/equatable.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();
  @override
  List<Object?> get props => [];
}

class GetCountriesEvent extends CountriesEvent {
  final String name;
  const GetCountriesEvent({required this.name});
  @override
  List<Object?> get props => [name];
}
