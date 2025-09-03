import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = constraints.maxWidth;

        // clamp entre 150 y 250
        final footerHeight = (screenHeight * 0.25).clamp(150.0, 250.0);

        final isMobile = screenWidth < 600;

        return Container(
          height: footerHeight,
          color: const Color(0xFF3B2B20),
          child: Stack(
            children: [
              // Logo en mobile: absoluto + transparente
              if (isMobile)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.08,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          "assets/images/footer.png",
                          fit: BoxFit.contain,
                          height: footerHeight * 0.9,
                        ),
                      ),
                    ),
                  ),
                ),

              // Contenido principal
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 20, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo normal solo en desktop
                    if (!isMobile)
                      Image.asset(
                        "assets/images/footer.png",
                        fit: BoxFit.contain
                      ),

                    if (!isMobile) const SizedBox(width: 32),

                    // Columna derecha
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Slogan responsivo
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final sloganFontSize = (constraints.maxWidth * 0.02 + 4) .clamp(10.0, 20.0) as double;

                              return Text(
                                "Velas artesanales talladas, velas únicas para iluminar tus espacios 🕯️",
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: sloganFontSize,
                                ),
                                textAlign: TextAlign.right,
                              );
                            },
                          ),

                          // Redes sociales con íconos desde assets
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Semantics(
                                label: 'Instagram de Lumbra: @lumbra_uruguay',
                                child: InkWell(
                                  onTap: () async {
                                    final Uri url = Uri.parse("https://instagram.com/lumbra_uruguay"); 
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(
                                        "assets/icons/instagram.png",
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "@lumbra_uruguay",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                              const SizedBox(height: 10),
                              Semantics(
                                label: 'WhatsApp de contacto +598 096 525 997',
                                child: InkWell(
                                  onTap: () async {
                                    final Uri url = Uri.parse("https://wa.me/59896525997"); 
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(
                                        "assets/icons/whatsapp.png",
                                        height: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "(+598) 096 525 997",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Semantics(
                                label: 'Página de Facebook: Lumbra Uruguay',
                                child: InkWell(
                                  onTap: () async { 
                                    final Uri url = Uri.parse("https://www.facebook.com/profile.php?id=61579415529558"); 
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  child: Row (
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image.asset(
                                          "assets/icons/facebook.png",
                                          height: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "Lumbra Uruguay",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )
                                  )
                                ),
                            ],
                          ),

                          // Copyright
                          const Text(
                            "© 2025 Lumbra. Todos los derechos reservados.",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
