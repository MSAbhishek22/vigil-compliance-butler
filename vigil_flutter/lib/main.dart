import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:vigil_client/vigil_client.dart';
import 'views/dashboard_view.dart';

/// Vigil - The High-Stakes Compliance Butler
/// 
/// Your digital guardian that watches over deadlines while you sleep.
void main() {
  // Initialize Serverpod client
  // Use 127.0.0.1 for better Web compatibility
  final client = Client(
    'http://127.0.0.1:8080/',
    // authenticationKeyManager: FlutterAuthenticationKeyManager(),
  );

  runApp(VigilApp(client: client));
}

class VigilApp extends StatelessWidget {
  final Client client;
  
  const VigilApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vigil - The Compliance Butler',
      debugShowCheckedModeBanner: false,
      theme: _buildVigilTheme(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/':
            page = DashboardView(client: client, initialTabIndex: 0);
            break;
          case '/requirements':
            page = DashboardView(client: client, initialTabIndex: 1);
            break;
          default:
            page = DashboardView(client: client, initialTabIndex: 0);
        }
        
        return MaterialPageRoute(
          builder: (context) => page,
          settings: settings,
        );
      },
    );
  }

  /// The "High-Stakes" Premium Dark Theme
  ThemeData _buildVigilTheme() {
    // Premium Palette
    const primaryColor = Color(0xFF2196F3);     // Electric Blue
    const accentColor = Color(0xFF00E676);      // Neon Green (Success)
    const backgroundColor = Color(0xFF0F172A);  // Deep Space Blue
    const surfaceColor = Color(0xFF1E293B);     // Slate Blue Surface
    const surfaceHighlight = Color(0xFF334155); // Lighter Slate
    const warningColor = Color(0xFFFFAB00);     // Amber Glow
    const dangerColor = Color(0xFFFF1744);      // Red Alert

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        surfaceContainerHigh: surfaceHighlight, // For cards
        error: dangerColor,
        tertiary: warningColor,
      ),
      fontFamily: 'Roboto', // Default, but use weights effectively
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
        }
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32, 
          fontWeight: FontWeight.w900, 
          letterSpacing: -1.0,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.white70,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          color: Colors.white54,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIconColor: accentColor,
        hintStyle: const TextStyle(color: Colors.white38),
      ),
    );
  }
}
