import 'package:injectable/injectable.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:prueba_jarboss/core/constants/urls.dart';
import 'package:prueba_jarboss/core/error.dart';
import 'package:prueba_jarboss/core/managers/network_manager.dart';
import 'package:prueba_jarboss/features/home/data/datasources/pokemon_list_datasource.dart';
import 'package:prueba_jarboss/features/home/data/models/pokemon_details_dto.dart';
import 'package:prueba_jarboss/features/home/data/models/pokemon_response_dto.dart';

@Injectable(as: PokemonListDataSource)
class PokemonListDataSourceImpl implements PokemonListDataSource {
  static final Map<String, PokemonResponseDto> _pokemonListCache = {};
  static final Map<String, PokemonDetailsDto> _pokemonDetailsCache = {};
  static final Map<String, Future<Result<PokemonResponseDto, NetworkError>>>
      _pokemonListRequests = {};
  static final Map<String, Future<Result<PokemonDetailsDto, NetworkError>>>
      _pokemonDetailsRequests = {};

  final NetworkManager _networkManager;

  PokemonListDataSourceImpl(this._networkManager);

  @override
  Future<Result<PokemonResponseDto, NetworkError>> getPokemonList() async {
    return _getPokemonListFromCache(Urls.getPokemon);
  }

  @override
  Future<Result<PokemonResponseDto, NetworkError>> loadMorePokemonList({
    required String nextUrl,
  }) async {
    return _getPokemonListFromCache(nextUrl);
  }

  @override
  Future<Result<PokemonDetailsDto, NetworkError>> getPokemonDetails({
    required String pokemonIndex,
  }) async {
    return _getPokemonDetailsFromCache(pokemonIndex);
  }

  Future<Result<PokemonResponseDto, NetworkError>> _getPokemonListFromCache(
    String url,
  ) {
    final cachedResponse = _pokemonListCache[url];
    if (cachedResponse != null) {
      return Future.value(Result.success(cachedResponse));
    }

    return _pokemonListRequests.putIfAbsent(
      url,
      () async {
        final request = Request(
          url: url,
          method: RequestType.get,
        );

        final result = await _networkManager.call<PokemonResponseDto>(
          mapper: PokemonResponseDto.fromJson,
          request: request,
        );

        if (result.isSuccess()) {
          _pokemonListCache[url] = result.getOrThrow();
        }

        return result;
      },
    ).whenComplete(() => _pokemonListRequests.remove(url));
  }

  Future<Result<PokemonDetailsDto, NetworkError>> _getPokemonDetailsFromCache(
    String pokemonIndex,
  ) {
    final cachedDetail = _pokemonDetailsCache[pokemonIndex];
    if (cachedDetail != null) {
      return Future.value(Result.success(cachedDetail));
    }

    return _pokemonDetailsRequests.putIfAbsent(
      pokemonIndex,
      () async {
        final request = Request(
          url: pokemonIndex,
          method: RequestType.get,
        );

        final result = await _networkManager.call<PokemonDetailsDto>(
          mapper: PokemonDetailsDto.fromJson,
          request: request,
        );

        if (result.isSuccess()) {
          _pokemonDetailsCache[pokemonIndex] = result.getOrThrow();
        }

        return result;
      },
    ).whenComplete(() => _pokemonDetailsRequests.remove(pokemonIndex));
  }
}
