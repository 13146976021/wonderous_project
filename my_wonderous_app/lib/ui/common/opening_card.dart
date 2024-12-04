import 'package:flutter/material.dart';


class OpeningCard extends StatefulWidget {
  const OpeningCard({super.key, required this.closedBuilder, required this.openBuilder, this.background, required this.isOpen, this.padding});

  final Widget Function(BuildContext) closedBuilder;
  final Widget Function(BuildContext) openBuilder;
  final Widget? background;
  final bool isOpen;
  final EdgeInsets? padding;


  @override
  State<OpeningCard> createState() => _OpeningCardState();
}

class _OpeningCardState extends State<OpeningCard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
