import 'package:chatbot_ai/shared/data/model/countries_model.dart';
import 'package:dio/dio.dart';

abstract class CountriesRemoteDatasource {
  Future<List<CountriesModel>> getCountries();
}

class CountriesRemoteDatasourceImpl implements CountriesRemoteDatasource {
  final Dio dio;
  const CountriesRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<CountriesModel>> getCountries() async {
    var response = await dio.get('/all?fields=name,flags,cca2');
    List data = response.data;
    return data
        .map(
          (e) => CountriesModel.fromMap({
            'country': e['name']['common'],
            'offical': e['name']['official'],
            'flag': e['flags']['png'],
          }),
        )
        .toList();
  }
}
