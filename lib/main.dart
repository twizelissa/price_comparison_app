import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_comparison_app/config/routes/app_router.dart';
import 'package:price_comparison_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:price_comparison_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:price_comparison_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:price_comparison_app/features/splash/presentation/pages/splash_screen.dart';
import 'package:price_comparison_app/core/services/cloudinary_service.dart';
import 'package:price_comparison_app/core/config/cloudinary_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock portrait mode initially (optional)
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  try {
    CloudinaryService.initialize(cloudName: CloudinaryConfig.cloudName);
    print('Cloudinary initialized successfully');
  } catch (e) {
    print('Cloudinary initialization error: $e');
  }
  
  runApp(const KigaliPriceCheckApp());
}

class KigaliPriceCheckApp extends StatelessWidget {
  const KigaliPriceCheckApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Kigali Price Check',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0, // Prevent system font size from affecting app
            ),
            child: child!,
          );
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}