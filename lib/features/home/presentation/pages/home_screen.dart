import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_jarboss/core/constants/app_dictionary.dart';
import 'package:prueba_jarboss/core/extensions/num_extensions.dart';
import 'package:prueba_jarboss/features/home/presentation/bloc/get_pokemon_list_bloc.dart';
import 'package:prueba_jarboss/features/home/presentation/widgets/pokemon_grid.dart';
import 'package:prueba_jarboss/features/home/presentation/widgets/searchbar_pokemon.dart';
import 'package:prueba_jarboss/theme/app_colors.dart';
import 'package:prueba_jarboss/theme/widgets/hb_scaffold_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<GetPokemonListBloc>().add(const GetPokemonInitializeEvent());
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<GetPokemonListBloc>();
    final canLoadMore = bloc.canLoadMore;

    return HbScaffoldWidget(
      body: SafeArea(
        child: BlocBuilder<GetPokemonListBloc, GetPokemonState>(
          builder: (context, state) {
            if (state is GetPokemonLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetPokemonLoaded) {
              return Container(
                color: AppColors.hbRedPrimary,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: SearchBarWidget(
                        controller: _searchController,
                        currentSortType: bloc.currentSortType,
                        onSearchChanged: (value) {
                          context
                              .read<GetPokemonListBloc>()
                              .add(SearchPokemonEvent(value));
                        },
                        onSortTap: () {
                          _showSortMenu(context);
                        },
                      ),
                    ),
                    20.ph,
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.grayScaleWhite,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: PokemonGridWidget(
                          pokemonList: state.pokemonList,
                          pokemonDetails: state.pokemonDetail,
                          canLoadMore: canLoadMore,
                          isLoadingMore: state.isLoadingMore,
                          onLoadMore: () {
                            context
                                .read<GetPokemonListBloc>()
                                .add(const LoadMorePokemonEvent());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is DrSearchError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(
                child: Text(AppDictionary.genericError),
              );
            }
          },
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext context) async {
    final selectedSort = await showMenu<SortType>(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 50, 0),
      items: [
        const PopupMenuItem(
          value: SortType.number,
          child: Text(AppDictionary.number),
        ),
        const PopupMenuItem(
          value: SortType.name,
          child: Text(AppDictionary.name),
        ),
      ],
    );

    if (selectedSort != null && context.mounted) {
      context.read<GetPokemonListBloc>().add(ChangeSortEvent(selectedSort));
    }
  }
}
