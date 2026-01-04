import 'package:chatbot_ai/core/data/datasource/remote%20datasource/countries_remote_datasource.dart';
import 'package:chatbot_ai/core/domain/entity/country_entity.dart';
import 'package:chatbot_ai/core/domain/repository/countries_repository.dart';
import 'package:chatbot_ai/core/errors/exceptions/dio_exception_handeller.dart';
import 'package:chatbot_ai/core/errors/failures/failures.dart';
import 'package:dio/dio.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDatasource countriesRemoteDatasource;
  const CountriesRepositoryImpl({required this.countriesRemoteDatasource});
  @override
  Future<List<CountriesEntity>> getCountries(String country) async {
    try {
      var data = await countriesRemoteDatasource.getCountries(country);
      return data.map((e) => e.toEntity()).toList();
    } on DioException catch (e) {
      var message = DioExceptionHandeler.getMessage(e);
      throw ApiFailure(message: message);
    }
  }
}
