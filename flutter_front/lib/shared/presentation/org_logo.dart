import 'dart:convert';

import 'package:flutter/cupertino.dart';

class LogoImage extends StatelessWidget {
  final String logoBase64;
  final double width;
  final double height;

  const LogoImage({
    super.key,
    required this.logoBase64,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      base64Decode(logoBase64),
      width: width,
      height: height,
    );
  }
}