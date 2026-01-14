import 'package:chatbot_ai/shared/domain/entity/country_entity.dart';
import 'package:chatbot_ai/shared/domain/repository/countries_repository.dart';

class GetCountriesUsecase {
  final CountriesRepository countryRepository;
  const GetCountriesUsecase({required this.countryRepository});

  Future<List<CountriesEntity>> call() async {
    return await countryRepository.getCountries();
  }
}
