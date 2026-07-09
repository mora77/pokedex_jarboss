import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_jarboss/core/constants/route_constants.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_details.dart';
import 'package:prueba_jarboss/features/home/domain/entities/pokemon_result.dart';
import 'package:prueba_jarboss/features/home/presentation/widgets/pokemon_card.dart';
import 'package:prueba_jarboss/theme/app_colors.dart';

class PokemonGridWidget extends StatefulWidget {
  final List<PokemonResult> pokemonList;
  final List<PokemonDetails> pokemonDetails;
  final bool canLoadMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const PokemonGridWidget({
    super.key,
    required this.pokemonList,
    required this.pokemonDetails,
    required this.canLoadMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  State<PokemonGridWidget> createState() => _PokemonGridWidgetState();
}

class _PokemonGridWidgetState extends State<PokemonGridWidget> {
  static const _loadMoreThreshold = 200.0;

  late final ScrollController _scrollController;
  bool _loadMoreRequested = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant PokemonGridWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isLoadingMore && !widget.isLoadingMore) {
      _loadMoreRequested = false;
    }

    if (!widget.canLoadMore) {
      _loadMoreRequested = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadMoreRequested ||
        widget.isLoadingMore ||
        !widget.canLoadMore ||
        !_scrollController.hasClients) {
      return;
    }

    if (_scrollController.position.extentAfter <= _loadMoreThreshold) {
      _loadMoreRequested = true;
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.pokemonList.length < widget.pokemonDetails.length
        ? widget.pokemonList.length
        : widget.pokemonDetails.length;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 170,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 104 / 108,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final detail = widget.pokemonDetails[index];
                final pokemon = widget.pokemonList[index];
                return PokemonCard(
                  number: detail.id,
                  pokemonName: pokemon.name,
                  pokemonImage: detail.sprites.frontDefault,
                  onTap: () {
                    context.push(
                      RouteConstants.detailsPokemon,
                      extra: {
                        "colorType": PokemonTypeColorMapper.getColorFromType(
                            detail.types[0].type.name),
                        "pokemon": pokemon,
                        "pokemonDetails": detail,
                      },
                    );
                  },
                );
              },
              childCount: itemCount,
            ),
          ),
        ),
        if (widget.isLoadingMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.hbRedPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
