import 'dart:ui';

import 'package:app/body/modules/navbar/navitem.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final bool isScrolled;
  const Navbar({super.key, required this.isScrolled});

  @override
  Widget build(BuildContext context) {

  final children = [
                NavItem(label: 'INICIO', path: '/',),
                NavItem(label: 'PRODUCTOS', path: '/productos'),
                NavItem(label: 'CATÁLOGO', path: '/catalogo'),
                NavItem(label: 'ESCRIBINOS', path: '/escribinos'),
              ];
  
  
  return Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 40, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final screenHeight = constraints.maxHeight;
                    final logoHeight = (screenHeight * 0.25).clamp(125.0, 175.0) as double;

                    return Image.asset(
                      'assets/images/logo_black.png',
                      height: logoHeight,
                    );
                  },
              ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(children.length * 2 - 1, (index) {
                  if (index.isEven) {
                    return children[index ~/ 2]; // 👈 el NavItem
                  } else {
                    return const SizedBox(height: 12); // 👈 el espacio
                  }
                }),
              )
            ],
          ),
        );
  }
}