import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // For now, just initialize GetIt without any dependencies
  // This prevents the initialization error
  print('Dependency injection initialized');
}
