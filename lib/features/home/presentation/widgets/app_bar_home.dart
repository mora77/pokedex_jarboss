import 'package:flutter/material.dart';
import 'package:prueba_jarboss/core/constants/app_assets.dart';
import 'package:prueba_jarboss/core/constants/app_dictionary.dart';
import 'package:prueba_jarboss/theme/app_colors.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: ImageIcon(
            const AssetImage(AppAssets.pokeballIcon),
            color: AppColors.grayScaleWhite,
            size: 24,
          ),
          title: const Text(AppDictionary.pokedex),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
