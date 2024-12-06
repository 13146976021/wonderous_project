import 'package:flutter/material.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/ui/common/measurable_widget.dart';


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
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {


    return TweenAnimationBuilder(
        tween: Tween(begin: _size,end: _size),
        duration: $styles.times.fast,
        curve: Curves.easeOut,
        builder: (_, value, child) => Stack(
          children: [
            if(widget.background != null) Positioned.fill(child: widget.background!),

            Padding(
                padding: widget.padding ?? EdgeInsets.zero,
                child: SizedBox(
                  width: value.width,
                  height: value.height,
                  child:  child,
                ),
            ),
          ],
        ),
        child:  AnimatedSwitcher(
          duration: $styles.times.fast,
          child: ClipRect(
            key: ValueKey(widget.isOpen),
            child: OverflowBox(
              minHeight: 0.0,
              minWidth: 0.0,
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              child: MeasurableWidget(
                onChange: (size){
                  setState(() {
                    _size = size;
                  });
                },
                child: widget.isOpen ? widget.openBuilder(context) : widget.closedBuilder(context),
              ),
            ),
          ),
        ),

    );
  }
}
