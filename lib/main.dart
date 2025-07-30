import 'package:flutter/material.dart';
import 'package:kigali_price_check/config/theme/app_theme.dart';
import 'package:kigali_price_check/config/theme/theme_data.dart' as app_theme;
import 'core/constants/app_strings.dart';
import 'config/routes/app_router.dart';
import 'config/routes/route_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme and preferences
  await app_theme.ThemeData.initialize();
  
  runApp(const KigaliPriceCheckApp());
}

class KigaliPriceCheckApp extends StatefulWidget {
  const KigaliPriceCheckApp({Key? key}) : super(key: key);

  @override
  State<KigaliPriceCheckApp> createState() => _KigaliPriceCheckAppState();
}

class _KigaliPriceCheckAppState extends State<KigaliPriceCheckApp> {
  @override
  void initState() {
    super.initState();
    // Add listeners for theme and settings changes
    app_theme.ThemeData.addThemeChangeListener(_updateTheme);
    app_theme.ThemeData.addSettingsChangeListener(_updateSettings);
  }

  @override
  void dispose() {
    // Remove listeners when widget is disposed
    app_theme.ThemeData.removeThemeChangeListener(_updateTheme);
    app_theme.ThemeData.removeSettingsChangeListener(_updateSettings);
    super.dispose();
  }

  void _updateTheme() {
    setState(() {}); // Rebuild with new theme settings
  }

  void _updateSettings() {
    setState(() {}); // Rebuild with new language/font size settings
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: app_theme.ThemeData.themeMode,
      locale: app_theme.ThemeData.locale,
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('rw', 'RW'), // Kinyarwanda
        Locale('fr', 'FR'), // French
      ],
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Apply font scaling to all text in the app
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: mediaQuery.textScaleFactor * app_theme.ThemeData.fontScaleFactor,
          ),
          child: child!,
        );
      },
    );
  }
}