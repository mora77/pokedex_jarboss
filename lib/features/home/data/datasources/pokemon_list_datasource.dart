import 'package:multiple_result/multiple_result.dart';
import 'package:prueba_jarboss/core/error.dart';
import 'package:prueba_jarboss/features/home/data/models/pokemon_details_dto.dart';
import 'package:prueba_jarboss/features/home/data/models/pokemon_response_dto.dart';

abstract interface class PokemonListDataSource {
  Future<Result<PokemonResponseDto, NetworkError>> getPokemonList();

  Future<Result<PokemonResponseDto, NetworkError>> loadMorePokemonList({
    required String nextUrl,
  });

  Future<Result<PokemonDetailsDto, NetworkError>> getPokemonDetails({
    required String pokemonIndex,
  });
}
