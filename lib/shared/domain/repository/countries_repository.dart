import 'package:chatbot_ai/shared/domain/entity/country_entity.dart';

abstract class CountriesRepository {
  Future<List<CountriesEntity>> getCountries(String country);
}
