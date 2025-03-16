import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_subscription_management/providers/subscription_provider.dart';
import 'package:user_subscription_management/screens/splash_screen.dart';

void main() {
    runApp(
      ChangeNotifierProvider(
        create: (_) => SubscriptionProvider(),
        child: MyApp(),
      ),
    );
  }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

