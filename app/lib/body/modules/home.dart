import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 400,
          color: Colors.brown,
          child: const Center(child: Text('Banner Home', style: TextStyle(color: Colors.white))),
        ),
        Container(
          height: 400,
          color: Colors.orange,
          child: const Center(child: Text('Contenido de ejemplo', style: TextStyle(color: Colors.white))),
        ),
      ],
    );
  }
}
