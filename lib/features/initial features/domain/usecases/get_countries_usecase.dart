import 'package:chatbot_ai/features/initial%20features/domain/entity/country_entity.dart';
import 'package:chatbot_ai/features/initial%20features/domain/repository/countries_repository.dart';

class GetCountriesUsecase {
  final CountriesRepository countryRepository;
  const GetCountriesUsecase({required this.countryRepository});

  Future<List<CountriesEntity>> call(String country) async {
    return await countryRepository.getCountries(country);
  }
}
