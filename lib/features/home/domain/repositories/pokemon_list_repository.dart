import 'package:multiple_result/multiple_result.dart';
import 'package:prueba_jarboss/core/error.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_details.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_response.dart';

abstract interface class PokemonListRepository {
  Future<Result<PokemonResponse, NetworkError>> getPokemonList();

  Future<Result<PokemonResponse, NetworkError>> loadMorePokemonList({
    required String nextUrl,
  });

  Future<Result<PokemonDetails, NetworkError>> getPokemonDetails({
    required String pokemonIndex,
  });
}
