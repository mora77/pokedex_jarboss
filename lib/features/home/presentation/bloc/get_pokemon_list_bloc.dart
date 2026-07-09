// ignore_for_file: avoid_print

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:prueba_jarboss/core/constants/app_dictionary.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_details.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_result.dart';
import 'package:prueba_jarboss/features/home/domain/usecases/get_pokemon_details_use_case.dart';
import 'package:prueba_jarboss/features/home/domain/usecases/get_pokemon_list_use_case.dart';
import 'package:prueba_jarboss/features/home/domain/usecases/load_more_pokemon_list_use_case.dart';

part 'get_pokemon_list_event.dart';
part 'get_pokemon_list_state.dart';

enum SortType {
  none,
  number,
  name,
}

@singleton
class GetPokemonListBloc extends Bloc<GetPokemonListEvent, GetPokemonState> {
  final GetPokemonListTokenUseCase _getPokemonList;
  final GetPokemonDetailsUseCase _getPokemonDetails;
  final LoadMorePokemonListTokenUseCase _loadMorePokemonDetails;

  GetPokemonListBloc(
    this._getPokemonList,
    this._getPokemonDetails,
    this._loadMorePokemonDetails,
  ) : super(GetPokemonInitial()) {
    on<GetPokemonInitializeEvent>(_onInitialize);
    on<GetPokemonDetailsEvent>(_onGetPokemonDetails);
    on<ChangeSortEvent>(_onChangeSort);
    on<SearchPokemonEvent>(_onSearch);
    on<LoadMorePokemonEvent>(_onLoadMore);
  }

  bool get canLoadMore => _nextUrl != null && _nextUrl!.isNotEmpty;
  SortType get currentSortType => _sortType;
  List<PokemonResult> _pokemonList = [];
  final Map<String, PokemonDetails> _pokemonDetailsByUrl = {};
  String? _nextUrl;
  SortType _sortType = SortType.none;
  String _searchQuery = '';
  bool _isLoadingMore = false;

  Future<void> _onInitialize(
    GetPokemonInitializeEvent event,
    Emitter<GetPokemonState> emit,
  ) async {
    emit(GetPokemonLoading());

    try {
      final pokemonListResult = await _getPokemonList.execute();

      if (!pokemonListResult.isSuccess()) {
        emit(const DrSearchError(AppDictionary.genericError));
        return;
      }

      final pokemonResponse = pokemonListResult.getOrThrow();
      _pokemonList = pokemonResponse.results;
      _nextUrl = pokemonResponse.next;

      if (_pokemonList.isNotEmpty) {
        add(const GetPokemonDetailsEvent());
      } else {
        emit(const GetPokemonLoaded(
          pokemonList: [],
          pokemonDetail: [],
        ));
      }
    } catch (e) {
      emit(DrSearchError('${AppDictionary.genericError}: $e'));
    }
  }

  Future<void> _onGetPokemonDetails(
    GetPokemonDetailsEvent event,
    Emitter<GetPokemonState> emit,
  ) async {
    if (_pokemonList.isEmpty) {
      emit(const DrSearchError(
        AppDictionary.genericError,
      ));
      return;
    }

    emit(GetPokemonLoading());

    try {
      await _loadMissingPokemonDetails(_pokemonList);

      final filteredAndSorted = _applyFiltersAndSorting();

      emit(
        GetPokemonLoaded(
          pokemonList: filteredAndSorted.results,
          pokemonDetail: filteredAndSorted.details,
        ),
      );
    } catch (e) {
      emit(DrSearchError('${AppDictionary.genericError}: $e'));
    }
  }

  Future<void> _onChangeSort(
    ChangeSortEvent event,
    Emitter<GetPokemonState> emit,
  ) async {
    _sortType = event.sortType;

    final filteredAndSorted = _applyFiltersAndSorting();

    emit(
      GetPokemonLoaded(
        pokemonList: filteredAndSorted.results,
        pokemonDetail: filteredAndSorted.details,
      ),
    );
  }

  Future<void> _onSearch(
    SearchPokemonEvent event,
    Emitter<GetPokemonState> emit,
  ) async {
    _searchQuery = event.query.trim();

    final filteredAndSorted = _applyFiltersAndSorting();

    emit(
      GetPokemonLoaded(
        pokemonList: filteredAndSorted.results,
        pokemonDetail: filteredAndSorted.details,
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMorePokemonEvent event,
    Emitter<GetPokemonState> emit,
  ) async {
    if (_isLoadingMore) {
      return;
    }

    if (_nextUrl == null || _nextUrl!.isEmpty) {
      final filteredAndSorted = _applyFiltersAndSorting();
      emit(
        GetPokemonLoaded(
          pokemonList: filteredAndSorted.results,
          pokemonDetail: filteredAndSorted.details,
          isLoadingMore: false,
        ),
      );
      return;
    }

    final currentState = state;
    if (currentState is GetPokemonLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
    }

    _isLoadingMore = true;

    try {
      final pokemonListResult =
          await _loadMorePokemonDetails.execute(_nextUrl ?? '');

      if (!pokemonListResult.isSuccess()) {
        emit(const DrSearchError(AppDictionary.genericError));
        return;
      }

      final pokemonResponse = pokemonListResult.getOrThrow();
      final morePokemon = pokemonResponse.results;
      _nextUrl = pokemonResponse.next;

      if (morePokemon.isEmpty) {
        final filteredAndSorted = _applyFiltersAndSorting();
        emit(
          GetPokemonLoaded(
            pokemonList: filteredAndSorted.results,
            pokemonDetail: filteredAndSorted.details,
            isLoadingMore: false,
          ),
        );
        return;
      }

      _pokemonList.addAll(morePokemon);

      await _loadMissingPokemonDetails(morePokemon);

      final filteredAndSorted = _applyFiltersAndSorting();

      emit(
        GetPokemonLoaded(
          pokemonList: filteredAndSorted.results,
          pokemonDetail: filteredAndSorted.details,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(DrSearchError('${AppDictionary.genericError}: $e'));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> _loadMissingPokemonDetails(
    List<PokemonResult> pokemonList,
  ) async {
    final missingPokemon = pokemonList
        .where((pokemon) => !_pokemonDetailsByUrl.containsKey(pokemon.url))
        .toList();

    if (missingPokemon.isEmpty) {
      return;
    }

    final allDetailResults = await Future.wait(
      missingPokemon.map((pokemon) async {
        final detailEither = await _getPokemonDetails.execute(pokemon.url);
        return (pokemon.url, detailEither);
      }),
    );

    for (final detailResult in allDetailResults) {
      detailResult.$2.when(
        (successDetail) {
          _pokemonDetailsByUrl[detailResult.$1] = successDetail;
        },
        (failure) {
          print("${AppDictionary.genericError} $failure");
        },
      );
    }
  }

  _FilteredData _applyFiltersAndSorting() {
    final combined = <(PokemonResult, PokemonDetails)>[];

    for (final pokemon in _pokemonList) {
      final pokemonDetails = _pokemonDetailsByUrl[pokemon.url];
      if (pokemonDetails != null) {
        combined.add((pokemon, pokemonDetails));
      }
    }

    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      final queryNumber = _normalizePokemonNumberQuery(queryLower);

      combined.retainWhere(
        (tuple) {
          final pokemonNumber = int.tryParse(tuple.$2.id)?.toString();

          return tuple.$1.name.toLowerCase().contains(queryLower) ||
              (queryNumber != null &&
                  pokemonNumber != null &&
                  pokemonNumber.contains(queryNumber));
        },
      );
    }

    switch (_sortType) {
      case SortType.none:
        break;

      case SortType.number:
        combined.sort((a, b) {
          final idA = int.tryParse(a.$2.id) ?? 0;
          final idB = int.tryParse(b.$2.id) ?? 0;
          return idA.compareTo(idB);
        });
        break;

      case SortType.name:
        combined.sort((a, b) => a.$1.name.compareTo(b.$1.name));
        break;
    }

    final filteredResults = combined.map((e) => e.$1).toList();
    final filteredDetails = combined.map((e) => e.$2).toList();

    return _FilteredData(
      results: filteredResults,
      details: filteredDetails,
    );
  }

  String? _normalizePokemonNumberQuery(String query) {
    final numberQuery = query.startsWith('#') ? query.substring(1) : query;

    if (numberQuery.isEmpty || int.tryParse(numberQuery) == null) {
      return null;
    }

    return int.parse(numberQuery).toString();
  }
}

class _FilteredData {
  final List<PokemonResult> results;
  final List<PokemonDetails> details;
  _FilteredData({required this.results, required this.details});
}
