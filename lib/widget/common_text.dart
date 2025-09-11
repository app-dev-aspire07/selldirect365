import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const CommonText({
    super.key,
    required this.text,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
