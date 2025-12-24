import 'package:chatbot_ai/features/initial%20features/domain/entity/country_entity.dart';

abstract class CountriesRepository {
  Future<List<CountriesEntity>> getCountries(String country);
}
