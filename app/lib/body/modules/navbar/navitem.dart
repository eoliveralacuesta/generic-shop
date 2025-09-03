import 'package:app/router/router_state.dart';
import 'package:app/theme/styles/hover.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavItem extends StatelessWidget {
  final String label;
  final String path;

  const NavItem({ super.key, required this.label, required this.path });

  @override
  Widget build(BuildContext context) {
    final currentPath = context.watch<RouterStateNotifier>().currentPath;
    final isActive = currentPath == path;
    final theme = Theme.of(context);

    return HoverBuilder(
      builder: (isHovered) {
        var baseStyle = theme.textTheme.titleLarge!;
        final highlightColor = theme.colorScheme.secondary;


        final styles = isActive || isHovered ? baseStyle.copyWith(
                                    color: highlightColor
                                  ) : baseStyle;

        return GestureDetector(
          onTap: () => context.go(path),
          child: SizedBox(
            width: 130,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: styles, // 👈 tu lógica de activo ya lo maneja
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 2,
                  width: isHovered ? 130 : 0, // 👈 solo hover, sin duplicar estilos
                  color: highlightColor,
                ),
              ],
            )
          )
        );
      },
    );
  }
}
