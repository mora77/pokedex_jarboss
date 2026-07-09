import 'package:flutter/material.dart';
import 'package:prueba_jarboss/core/constants/app_assets.dart';

BoxDecoration backgroundPokemonType({required Color overlayColor}) {
  return BoxDecoration(
    image: DecorationImage(
      image: const AssetImage(AppAssets.backgroundPokemonType),
      fit: BoxFit.cover,
      colorFilter: ColorFilter.mode(
        overlayColor,
        BlendMode.color,
      ),
    ),
  );
}
