// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/dashboard/presentation/bloc/dashboard_navigation_cubit.dart'
    as _i946;
import '../../features/home/data/datasources/pokemon_list_datasource.dart'
    as _i870;
import '../../features/home/data/datasources/pokemon_list_datasource_impl.dart'
    as _i568;
import '../../features/home/data/repositories/pokemon_list_repository_impl.dart'
    as _i115;
import '../../features/home/domain/repositories/pokemon_list_repository.dart'
    as _i893;
import '../../features/home/domain/usecases/get_pokemon_details_use_case.dart'
    as _i799;
import '../../features/home/domain/usecases/get_pokemon_list_use_case.dart'
    as _i165;
import '../../features/home/domain/usecases/load_more_pokemon_list_use_case.dart'
    as _i684;
import '../../features/home/presentation/bloc/get_pokemon_list_bloc.dart'
    as _i855;
import '../../features/splash/presentation/cubit/splash_cubit.dart' as _i125;
import '../managers/network_manager.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i291.NetworkManager>(() => _i291.NetworkManager());
    gh.singleton<_i946.DashboardNavigationCubit>(
        () => _i946.DashboardNavigationCubit());
    gh.lazySingleton<_i125.SplashCubit>(() => _i125.SplashCubit());
    gh.factory<_i870.PokemonListDataSource>(
        () => _i568.PokemonListDataSourceImpl(gh<_i291.NetworkManager>()));
    gh.factory<_i893.PokemonListRepository>(() =>
        _i115.PokemonListRepositoryImpl(gh<_i870.PokemonListDataSource>()));
    gh.lazySingleton<_i165.GetPokemonListTokenUseCase>(() =>
        _i165.GetPokemonListTokenUseCase(gh<_i893.PokemonListRepository>()));
    gh.lazySingleton<_i684.LoadMorePokemonListTokenUseCase>(() =>
        _i684.LoadMorePokemonListTokenUseCase(
            gh<_i893.PokemonListRepository>()));
    gh.lazySingleton<_i799.GetPokemonDetailsUseCase>(() =>
        _i799.GetPokemonDetailsUseCase(gh<_i893.PokemonListRepository>()));
    gh.singleton<_i855.GetPokemonListBloc>(() => _i855.GetPokemonListBloc(
          gh<_i165.GetPokemonListTokenUseCase>(),
          gh<_i799.GetPokemonDetailsUseCase>(),
          gh<_i684.LoadMorePokemonListTokenUseCase>(),
        ));
    return this;
  }
}
