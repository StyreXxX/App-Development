import 'package:flutter/material.dart';


class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFB08968), // Coffee brown as seed
      brightness: Brightness.light,
      primary: Color(0xFFB08968), // Coffee brown
      secondary: Color(0xFFDDB892), // Latte beige
      surface: Color(0xFFFFFFFF), // White
      onSurface: Color(0xFF3E2723), // Dark coffee text
      background: Color(0xFFF8F4EF), // Creamy coffee daylight
      onBackground: Color(0xFF3E2723), // Dark coffee text
    ),
    scaffoldBackgroundColor: Color(0xFFF8F4EF), // Match background
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF3E2723), // Dark coffee text
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF3E2723)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB08968), // Coffee brown
        foregroundColor: Color(0xFFFFFFFF), // White for contrast
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFFB08968), // Coffee brown
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Color(0xFFDDB892).withOpacity(0.8), // Latte beige
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Color(0xFFFFFFFF).withOpacity(0.85), // White surface
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3E2723), // Dark coffee text
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF3E2723)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFFDDB892), // Latte beige as seed
      brightness: Brightness.dark,
      primary: Color(0xFFDDB892), // Latte beige
      secondary: Color(0xFFB08968), // Coffee brown
      surface: Color(0xFF2E2A25), // Dark surface
      onSurface: Color(0xFFEFEFEF), // Light text
      background: Color(0xFF1C1B18), // Chocolate night
      onBackground: Color(0xFFEFEFEF), // Light text
    ),
    scaffoldBackgroundColor: Color(0xFF1C1B18), // Match background
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFFEFEFEF), // Light text
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFFEFEFEF)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFDDB892), // Latte beige
        foregroundColor: Color(0xFF1C1B18), // Dark for contrast
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFFDDB892), // Latte beige
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Color(0xFFB08968).withOpacity(0.8), // Coffee brown
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Color(0xFF2E2A25).withOpacity(0.85), // Dark surface
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFFEFEFEF), // Light text
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFEFEFEF)),
    ),
  );
}



// class ThemeConfig {
//   /// 🌸 PALE LAVENDER AND SLATE THEME
//   /// Soft, elegant theme with pale lavender and slate gray tones for a calming, aesthetic feel.

// static ThemeData lightTheme = ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: Color(0xFF8AB4A8), // Seafoam green as seed
//       brightness: Brightness.light,
//       primary: Color(0xFF8AB4A8), // Seafoam green
//       secondary: Color(0xFFA8B4A8), // Stone gray
//       surface: Color(0xFFFFFFFF), // White
//       onSurface: Color(0xFF406E61), // Dark seafoam text
//       background: Color(0xF5F9F7), // Light seafoam-gray
//       onBackground: Color(0xFF406E61), // Dark seafoam text
//     ),
//     scaffoldBackgroundColor: Color(0xF5F9F7), // Match background
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.transparent,
//       foregroundColor: Color(0xFF406E61), // Dark seafoam text
//       elevation: 0,
//       iconTheme: IconThemeData(color: Color(0xFF406E61)),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color(0xFF8AB4A8), // Seafoam green
//         foregroundColor: Color(0xFFFFFFFF), // White for contrast
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 0,
//       ),
//     ),
//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: Color(0xFF8AB4A8), // Seafoam green
//         textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide.none,
//       ),
//       filled: true,
//       fillColor: Color(0xFFA8B4A8).withOpacity(0.8), // Stone gray
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     ),
//     cardTheme: CardThemeData(
//       elevation: 0,
//       color: Color(0xFFFFFFFF).withOpacity(0.85), // Half-transparent white
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     ),
//     textTheme: const TextTheme(
//       headlineMedium: TextStyle(
//         fontSize: 28,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF406E61), // Dark seafoam text
//       ),
//       bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF406E61)),
//     ),
//   );

//   static ThemeData darkTheme = ThemeData(
//     useMaterial3: true,
//     colorScheme: ColorScheme.fromSeed(
//       seedColor: Color(0xFFA8B4A8), // Stone gray as seed
//       brightness: Brightness.dark,
//       primary: Color(0xFFA8B4A8), // Stone gray
//       secondary: Color(0xFF8AB4A8), // Seafoam green
//       surface: Color(0xFF2F3F3A), // Dark stone
//       onSurface: Color(0xFFDDE7E3), // Light seafoam-gray text
//       background: Color(0xFF1F2B28), // Deep seafoam
//       onBackground: Color(0xFFDDE7E3), // Light seafoam-gray text
//     ),
//     scaffoldBackgroundColor: Color(0xFF1F2B28), // Match background
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.transparent,
//       foregroundColor: Color(0xFFDDE7E3), // Light seafoam-gray text
//       elevation: 0,
//       iconTheme: IconThemeData(color: Color(0xFFDDE7E3)),
//     ),
//     elevatedButtonTheme: ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color(0xFFA8B4A8), // Stone gray
//         foregroundColor: Color(0xFF1F2B28), // Deep seafoam for contrast
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 0,
//       ),
//     ),
//     textButtonTheme: TextButtonThemeData(
//       style: TextButton.styleFrom(
//         foregroundColor: Color(0xFFA8B4A8), // Stone gray
//         textStyle: const TextStyle(fontWeight: FontWeight.w600),
//       ),
//     ),
//     inputDecorationTheme: InputDecorationTheme(
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide.none,
//       ),
//       filled: true,
//       fillColor: Color(0xFF8AB4A8).withOpacity(0.8), // Seafoam green
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     ),
//     cardTheme: CardThemeData(
//       elevation: 0,
//       color: Color(0xFF2F3F3A).withOpacity(0.85), // Half-transparent dark stone
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     ),
//     textTheme: const TextTheme(
//       headlineMedium: TextStyle(
//         fontSize: 28,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFFDDE7E3), // Light seafoam-gray text
//       ),
//       bodyMedium: TextStyle(fontSize: 16, color: Color(0xFFDDE7E3)),
//     ),
//   );
// }
