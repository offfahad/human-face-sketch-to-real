import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:human_face_generator/src/features/btm_bar.dart';
import 'package:human_face_generator/src/features/liveSketching/screens/drawing_screen_desktop.dart';
import 'package:human_face_generator/src/features/liveSketching/screens/drawing_screen_mobile.dart';
import 'package:human_face_generator/src/features/responsive_layout.dart';

class DrawingResponsiveLayout extends StatefulWidget {
  const DrawingResponsiveLayout({super.key});

  @override
  State<DrawingResponsiveLayout> createState() => _DrawingResponsiveLayoutState();
}

class _DrawingResponsiveLayoutState extends State<DrawingResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(mobileBody: BottomBarScreen(), desktopBody: DrawingScreenDesktop());
  }
}