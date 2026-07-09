import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:prueba_jarboss/core/error.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_details.dart';
import 'package:prueba_jarboss/features/home/domain/repositories/pokemon_list_repository.dart';

@lazySingleton
class GetPokemonDetailsUseCase {
  final PokemonListRepository _pokemonDetailsRepository;

  GetPokemonDetailsUseCase(this._pokemonDetailsRepository);

  Future<Result<PokemonDetails, NetworkError>> execute(
      String pokemonIndex) async {
    return await _pokemonDetailsRepository.getPokemonDetails(
      pokemonIndex: pokemonIndex,
    );
  }
}
