import 'package:flutter/material.dart';
import 'package:national_lawyer_assistant/home.dart';

class SplashScreen extends StatefulWidget {
  final Widget? widget;
  SplashScreen({Key? key, this.widget = const HomeScreen()});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticInOut,
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          if (widget.widget == HomeScreen()) {
            Navigator.pop(context);
          } else {
            Navigator.of(context).pushReplacement(_createRoute());
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget.widget!,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final String logoAsset = isDarkMode
        ? "assets/images/AppLogo.png"
        : "assets/images/AppLogoDark.png";
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value * 2,
              child: Transform.rotate(
                angle: _animation.value * 2 * 3.1416,
                child: child,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                logoAsset,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
