import 'package:app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:app/router/router.dart';
import 'package:provider/provider.dart';
import 'package:app/router/router_state.dart'; // 👈 el notifier que definimos

void main() {
  usePathUrlStrategy(); // saca el # de la URL
  runApp(
    ChangeNotifierProvider(
      create: (_) => RouterStateNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lumbra',
      theme: LumbraTheme.light,
      // darkTheme: LumbraTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
