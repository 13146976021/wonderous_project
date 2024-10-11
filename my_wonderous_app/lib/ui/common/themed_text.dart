import 'package:flutter/material.dart';
import 'package:wonders/main.dart';


class DefaultTextColor extends StatelessWidget {
  const DefaultTextColor({super.key,required this.color, required this.child});
  final Color color;
  final Widget child;


  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(color: color),
        child: child
    );
  }
}


class DrakText extends StatelessWidget {
  const DrakText({super.key,required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextColor(
        color: $styles.colors.black,
        child: child);
  }
}
