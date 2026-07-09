import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:prueba_jarboss/core/error.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_response.dart';
import 'package:prueba_jarboss/features/home/domain/repositories/pokemon_list_repository.dart';

@lazySingleton
class LoadMorePokemonListTokenUseCase {
  final PokemonListRepository _pokemonListRepository;

  LoadMorePokemonListTokenUseCase(this._pokemonListRepository);

  Future<Result<PokemonResponse, NetworkError>> execute(String nextUrl) async {
    return await _pokemonListRepository.loadMorePokemonList(
      nextUrl: nextUrl,
    );
  }
}
