import 'dart:async';

import 'package:chatbot_ai/core/bloc/countries%20bloc/countries_event.dart';
import 'package:chatbot_ai/core/bloc/countries%20bloc/countries_state.dart';
import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/shared/domain/usecases/get_countries_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetCountriesUsecase getCountriesUsecase;
  CountriesBloc({required this.getCountriesUsecase})
    : super(CountriesInitial()) {
    on<GetCountriesEvent>(onGetCountriesEvent);
    on<OnChangedCountriesEvent>(onChangedCountriesEvent);
  }

  FutureOr<void> onGetCountriesEvent(
    GetCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    try {
      emit(CountriesLoading());

      var data = await getCountriesUsecase();

      emit(CountriesLoaded(allCountries: data, filteredCountries: data));
    } on Failures catch (e) {
      emit(CountriesError(message: e.message));
    }
  }

  Future<void> onChangedCountriesEvent(
    OnChangedCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    if (state is CountriesLoaded) {
      final loaded = state as CountriesLoaded;

      if (event.query.isEmpty) {
        emit(
          CountriesLoaded(
            allCountries: loaded.allCountries,
            filteredCountries: loaded.allCountries,
          ),
        );
        return;
      }

      final filtered = loaded.allCountries
          .where(
            (element) => element.country.toLowerCase().startsWith(
              event.query.toLowerCase().trim(),
            ),
          )
          .toList();

      emit(
        CountriesLoaded(
          allCountries: loaded.allCountries,
          filteredCountries: filtered,
        ),
      );
    }
  }
}
