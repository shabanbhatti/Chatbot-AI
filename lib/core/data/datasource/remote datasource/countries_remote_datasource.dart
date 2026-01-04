import 'package:chatbot_ai/core/data/model/countries_model.dart';
import 'package:dio/dio.dart';

abstract class CountriesRemoteDatasource {
  Future<List<CountriesModel>> getCountries(String country);
}

class CountriesRemoteDatasourceImpl implements CountriesRemoteDatasource {
  final Dio dio;
  const CountriesRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<CountriesModel>> getCountries(String country) async {
    var response = await dio.get('/$country');
    List data = response.data;
    return data
        .map(
          (e) => CountriesModel.fromMap({
            'country': e['name']['common'],
            'offical': e['name']['official'],
            'flag': e['flag'],
          }),
        )
        .toList();
  }
}
