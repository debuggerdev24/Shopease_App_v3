import 'package:flutter/material.dart';

class GlobalText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final TextOverflow? textOverflow;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final double? height;
  final int? maxLine;
  final List<Shadow>? shadows;
  final TextStyle? textStyle;
  const GlobalText(
      this.text, {
        Key? key,
        this.height,
        this.fontSize,
        this.fontWeight,
        this.fontFamily,
        this.color,
        this.textDecoration,
        this.textOverflow,
        this.fontStyle = FontStyle.normal,
        this.letterSpacing,
        this.textAlign,
        this.maxLine,
        this.shadows,
        this.textStyle,
      }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final fontTextStyle = TextStyle(
      fontFamily: fontFamily ?? 'Sans',
      color: color,
      height: height ?? 1.2,
      overflow: textOverflow,
      fontSize: fontSize,
      fontWeight: fontWeight,
      decoration: textDecoration,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      shadows: shadows,


    );
    return Text(

      text,
      textAlign: textAlign,
      maxLines: maxLine,
      locale: Locale('ar', 'sa'),
      style: textStyle ?? fontTextStyle,
    );
  }
}
