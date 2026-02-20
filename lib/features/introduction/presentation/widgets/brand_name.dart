import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandName extends StatelessWidget {
  final double? fontSize;
  const BrandName({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Yaanam',
      style: GoogleFonts.spicyRice(
        textStyle: TextStyle(
          fontSize: fontSize ?? 36,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),
      ),
    );
  }
}
