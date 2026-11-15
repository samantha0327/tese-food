import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/accessibility_provider.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const TeseApp());
}

class TeseApp extends StatelessWidget {
  const TeseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccessibilityProvider(),
      child: Consumer<AccessibilityProvider>(
        builder: (context, access, _) {
          return MaterialApp(
            title: 'Cafetería TESE',
            debugShowCheckedModeBanner: false,
            // El textScaleFactor se aplica globalmente
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(access.textScaleFactor),
                ),
                child: child!,
              );
            },
            theme: AppTheme.theme,
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
