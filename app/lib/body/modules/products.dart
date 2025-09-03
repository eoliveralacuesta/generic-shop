import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:web/web.dart' as web;
import 'package:http/http.dart' as http;
import 'package:app/theme/styles/hover.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  static const String BASE_URL = "http://localhost:8080/api";

  Future<String> fetchSignedUrlFromBackend() async {
    final response = await http.get(Uri.parse('$BASE_URL/auth'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return '$BASE_URL/catalog?token=${data['token']}';
    } else {
      throw Exception("Error obteniendo URL del catálogo");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/candle_bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Souvenirs personalizados, artesanías y decoración que renuevan tu espacio ✨",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),

          const SizedBox(height: 20),

          Text(
            "¿Te interesa conocer más sobre nuestros productos?",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),

          const SizedBox(height: 100),

          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón Catálogo PDF
              Semantics(
                label: 'Descargar catálogo en PDF',
                child: HoverBuilder(
                  builder: (hovering) {
                    return AnimatedScale(
                      scale: hovering ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      alignment: Alignment.center, // 👈 escala desde el centro
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          boxShadow: hovering
                              ? [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withValues(alpha: 0.5),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final signedUrl = await fetchSignedUrlFromBackend();
                            web.HTMLAnchorElement()
                              ..href = signedUrl
                              ..download = "Lumbra 2025.pdf"
                              ..click();
                          },
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text("Ver catálogo en PDF"),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Botón Instagram
              Semantics(
                label: 'Ver catálogo resumido de productos en Instagram',
                child: HoverBuilder(
                  builder: (hovering) {
                    return AnimatedScale(
                      scale: hovering ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      alignment: Alignment.center,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          boxShadow: hovering
                              ? [
                                  BoxShadow(
                                    color: Colors.orangeAccent.withValues(alpha: 0.5),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final Uri url = Uri.parse(
                              "https://www.instagram.com/stories/highlights/17876941902366265",
                            );
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.favorite_border),
                          label: const Text("Ver productos en Instagram"),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
