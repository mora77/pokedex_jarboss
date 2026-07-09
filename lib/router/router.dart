import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_jarboss/core/constants/route_constants.dart';
import 'package:prueba_jarboss/core/di/injection.dart';
import 'package:prueba_jarboss/features/dashboard/presentation/bloc/dashboard_navigation_cubit.dart';
import 'package:prueba_jarboss/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:prueba_jarboss/features/details/presentation/pages/detail_pokemon_screen.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_details.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_result.dart';
import 'package:prueba_jarboss/features/home/presentation/bloc/get_pokemon_list_bloc.dart';
import 'package:prueba_jarboss/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:prueba_jarboss/features/splash/presentation/pages/splash_screen.dart';

class TestRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: RouteConstants.initialRoute,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider.value(
            value: getIt<SplashCubit>()..fetchConfigurationInfo(),
            child: const SplashScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.dashboardRoute,
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<DashboardNavigationCubit>()),
              BlocProvider.value(value: getIt<GetPokemonListBloc>()),
            ],
            child: const DashboardScreen(),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.detailsPokemon,
        builder: (BuildContext context, GoRouterState state) {
          final extra = state.extra as Map<String, dynamic>;
          Color colorType = extra['colorType'];
          PokemonResult pokemon = extra['pokemon'];
          PokemonDetails pokemonDetails = extra['pokemonDetails'];
          return DetailPokemonScreen(
            colorType: colorType,
            pokemon: pokemon,
            pokemonDetails: pokemonDetails,
          );
        },
      ),
    ],
  );
}
