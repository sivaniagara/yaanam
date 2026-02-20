import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class BrandQuotes extends StatelessWidget {
  final double? fontSize;
  const BrandQuotes({super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Life Is Adventure Make The Best Of It',
      style: GoogleFonts.spicyRice(
        textStyle: TextStyle(
          fontSize: fontSize ?? 9,
          color: Colors.black,
        ),
      ),
    );
  }
}
