import 'dart:async';

import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:chatbot_ai/features/initial%20features/domain/usecases/get_countries_usecase.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/countries%20bloc/countries_event.dart';
import 'package:chatbot_ai/features/initial%20features/presentation/bloc/countries%20bloc/countries_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetCountriesUsecase getCountriesUsecase;
  CountriesBloc({required this.getCountriesUsecase})
    : super(CountriesInitial()) {
    on<GetCountriesEvent>(onGetCountriesEvent);
  }

  FutureOr<void> onGetCountriesEvent(
    GetCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    try {
      emit(CountriesLoading());
      var data = await getCountriesUsecase(event.name);
      emit(CountriesLoaded(data));
    } on Failures catch (e) {
      emit(CountriesError(message: e.message));
    }
  }
}
