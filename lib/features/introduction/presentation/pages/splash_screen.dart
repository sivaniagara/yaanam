import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:yaanam/core/constant/app_images.dart';
import 'package:yaanam/features/introduction/presentation/widgets/brand_name.dart';
import 'package:yaanam/features/introduction/presentation/widgets/brand_quotes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _mapOpacity;
  late Animation<double> _mapScale;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;

  late Animation<Offset> _statueSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    /// Map animation - starts immediately, slightly faster zoom
    _mapOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _mapScale = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      ),
    );

    /// Logo animation - pops in smoothly
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.2, 0.7, curve: Curves.easeInBack),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5),
      ),
    );

    /// Text animation - slides up gracefully
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.fastOutSlowIn),
      ),
    );

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8),
      ),
    );

    /// Statue animation - rises from bottom
    _statueSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    _controller.forward().then((_) {
      if (mounted) {
        context.go('/welcomeScreen');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// MAP
            FadeTransition(
              opacity: _mapOpacity,
              child: ScaleTransition(
                scale: _mapScale,
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.map,
                    height: MediaQuery.of(context).size.height * 1.2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            /// CENTER CONTENT
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// LOGO
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Image.asset(
                        AppImages.logo,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// APP NAME
                  FadeTransition(
                    opacity: _textOpacity,
                    child: SlideTransition(
                      position: _textSlide,
                      child: const BrandName(),
                    ),
                  ),

                  /// TAGLINE
                  FadeTransition(
                    opacity: _textOpacity,
                    child: const BrandQuotes(),
                  ),
                ],
              ),
            ),

            /// STATUE
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _statueSlide,
                child: Image.asset(
                  AppImages.statue,
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
