import 'package:flutter/material.dart';
import 'package:whdanz/core/constants/app_constants.dart';
import 'package:whdanz/core/router/app_router.dart';
import 'package:whdanz/core/theme/app_theme.dart';

class WhDanzApp extends StatelessWidget {
  const WhDanzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
