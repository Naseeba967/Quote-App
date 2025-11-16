import 'package:code_alpha_quote_app/providers/quote_provider.dart';
import 'package:code_alpha_quote_app/screens/quote_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Daily Quote ',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const QuoteScreen(),
      ),
    );
  }
}
