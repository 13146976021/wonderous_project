import 'package:flutter/material.dart';
class CenteredBox extends StatelessWidget {
  const CenteredBox({super.key, required this.child, this.height, this.width ,this.padding});
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsets? padding;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: child,
        ),
      ),
    );
  }
}
