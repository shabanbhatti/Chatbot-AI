import 'package:chatbot_ai/core/domain/entity/country_entity.dart';
import 'package:chatbot_ai/core/domain/repository/countries_repository.dart';

class GetCountriesUsecase {
  final CountriesRepository countryRepository;
  const GetCountriesUsecase({required this.countryRepository});

  Future<List<CountriesEntity>> call(String country) async {
    return await countryRepository.getCountries(country);
  }
}
