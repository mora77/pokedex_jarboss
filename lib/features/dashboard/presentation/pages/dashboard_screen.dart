import 'package:flutter/material.dart';
import 'package:prueba_jarboss/core/di/injection.dart';
import 'package:prueba_jarboss/features/dashboard/presentation/bloc/dashboard_navigation_cubit.dart';
import 'package:prueba_jarboss/features/dashboard/utils/loading_mixin.dart';
import 'package:prueba_jarboss/features/home/presentation/pages/home_screen.dart';
import 'package:prueba_jarboss/features/home/presentation/widgets/app_bar_home.dart';
import 'package:prueba_jarboss/theme/app_colors.dart';
import 'package:prueba_jarboss/theme/widgets/hb_scaffold_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver, LoadingMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getIt<DashboardNavigationCubit>().init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HbScaffoldWidget(
      appBar: const AppBarHome(),
      backgroundColor: AppColors.hbRedPrimary,
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: HomeScreen(),
      ),
    );
  }
}
