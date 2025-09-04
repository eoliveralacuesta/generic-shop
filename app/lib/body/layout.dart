import 'package:app/body/modules/footer.dart';
import 'package:app/body/modules/navbar/navbar.dart';
import 'package:flutter/material.dart';

class Layout extends StatefulWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 100;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/kraft_bg.webp"),
            fit: BoxFit.contain,
            repeat: ImageRepeat.repeat,
            alignment: Alignment.topLeft,
            colorFilter: ColorFilter.mode(
              Colors.white30,
              BlendMode.srcATop,
            ),
          ),
        ),
        child: CustomScrollView(
  controller: _scrollController,
  slivers: [
    // Navbar
    SliverToBoxAdapter(
      child: Navbar(isScrolled: _isScrolled),
    ), //Va siempre arriba, y tiene el controlador para saber si scrolleó o no

    // Contenido + Footer
    SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          // Contenido que se adapta
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: widget.child,
          ),
        ],
      ),

    ),

    SliverToBoxAdapter(
        child: const Footer(),
    ), //Funciona igual que el header, tiene que ir siempre al final, no importa el contenido del medio
  ],
),
      ),
    );
  }
}
