import 'package:app/body/layout.dart';
import 'package:app/body/modules/home.dart';
import 'package:app/body/modules/products/products_page.dart';
import 'package:app/body/modules/catalog.dart';
import 'package:app/router/router_state.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        context.read<RouterStateNotifier>().updatePath(state.uri.path); // 👈 acá se actualiza
        return Layout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/productos',
          builder: (context, state) {
            final queryParams = state.uri.queryParameters;
            return ProductsPage(params: queryParams);
          },
        ),
        GoRoute(
          path: '/catalogo',
          builder: (context, state) => const CatalogPage(),
        ),
      ]
     ),
  ]
);