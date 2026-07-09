import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:prueba_jarboss/core/constants/app_assets.dart';

class PokemonImageWidget extends StatelessWidget {
  final String? pokemonImage;
  final double? height;
  final String loadingAsset;

  const PokemonImageWidget({
    super.key,
    this.pokemonImage,
    this.height,
    this.loadingAsset = AppAssets.pokeballLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isValidUrl = pokemonImage != null && pokemonImage!.isNotEmpty;

    if (!isValidUrl) {
      return _PokemonImageLoading(
        loadingAsset: loadingAsset,
      );
    }

    return Image.network(
      pokemonImage!,
      height: height,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }

        return _PokemonImageLoading(
          loadingAsset: loadingAsset,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return _PokemonImageLoading(
          loadingAsset: loadingAsset,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _PokemonImageLoading(
          loadingAsset: loadingAsset,
        );
      },
    );
  }
}

class _PokemonImageLoading extends StatelessWidget {
  final String loadingAsset;

  const _PokemonImageLoading({
    required this.loadingAsset,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const maxHeight = 100.0;
        const maxWidth = 100.0;
        final animationSize = math.min(maxHeight, maxWidth);

        return Center(
          child: SizedBox.square(
            dimension: animationSize,
            child: Lottie.asset(
              loadingAsset,
              fit: BoxFit.contain,
              frameRate: FrameRate.max,
            ),
          ),
        );
      },
    );
  }
}
