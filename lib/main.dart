import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'config/routes/app_router.dart';
import 'config/routes/route_names.dart';

void main() {
  runApp(const KigaliPriceCheckApp());
}

class KigaliPriceCheckApp extends StatelessWidget {
  const KigaliPriceCheckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
