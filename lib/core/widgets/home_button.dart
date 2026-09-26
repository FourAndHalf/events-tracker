import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App icon for AppBar.leading: tapping it goes to the home dashboard.
class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Home',
    onPressed: () => context.go('/'),
    icon: Image.asset('assets/icon/splash_logo.png', width: 32, height: 32),
  );
}
