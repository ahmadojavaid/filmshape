import 'dart:ui';

import 'package:flutter/material.dart';

// Hexagon clip path
class HexagonClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path hexagon = new Path();
    hexagon.moveTo(size.width * 0.5, 0.0);
    hexagon.lineTo(size.width * 0.93, size.height * 0.25);
    hexagon.lineTo(size.width * 0.93, size.height * 0.75);
    hexagon.lineTo(size.width * 0.5, size.height);
    hexagon.lineTo(size.width * 0.07, size.height * 0.75);
    hexagon.lineTo(size.width * 0.07, size.height * 0.25);
    hexagon.close();
    return hexagon;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// Sloped bottom clip path
class SlopedBottomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path slopedBottom = new Path();
    slopedBottom.moveTo(0.0, 0.0);
    slopedBottom.lineTo(size.width, 0.0);
    slopedBottom.lineTo(size.width, size.height * 0.7);
    slopedBottom.lineTo(0.0, size.height * 0.95);
    slopedBottom.close();
    return slopedBottom;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
