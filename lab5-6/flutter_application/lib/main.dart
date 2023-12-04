import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'list_grades.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      onInitCallback: (controller, previouslySavedThemeFuture) async {
        var savedTheme = await previouslySavedThemeFuture;
        if (savedTheme != null) {
          controller.setTheme(savedTheme);
        }
      },
      themes: <AppTheme>[
        AppTheme(
          id: "light_theme",
          description: "Light Theme",
          data: ThemeData.light(),
        ),
        AppTheme(
          id: "dark_theme",
          description: "Dark Theme",
          data: ThemeData.dark(),
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) {
            return MaterialApp(
              title: 'Grade Management App',
              theme: ThemeProvider.themeOf(themeContext).data,
              home: ListGrades(),
            );
          },
        ),
      ),
    );
  }
}
