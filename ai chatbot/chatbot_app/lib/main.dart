import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/router/app_router.dart';
import 'providers/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load();
  } catch (e) {
    // Gracefully handle missing .env file (ok for web during dev)
    print('Note: Could not load .env file: $e');
  }

  // For WEB: Token must be set from environment or backend proxy
  // For MOBILE/DESKTOP: Token loaded from .env file
  // See lib/services/huggingface_service.dart for token configuration
  
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppState())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Customer Support Chatbot',
      routerConfig: AppRouter.router,
      theme: ThemeData(useMaterial3: true),
    );
  }
}
