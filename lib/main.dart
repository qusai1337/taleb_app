import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('languageCode') ?? 'en';

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      fallbackLocale: Locale('en'),
      startLocale: Locale(savedLang),
      child: const TalebApp(),
    ),
  );
}

class TalebApp extends StatelessWidget {
  const TalebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taleb+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: WelcomePage(),
    );
  }
}
