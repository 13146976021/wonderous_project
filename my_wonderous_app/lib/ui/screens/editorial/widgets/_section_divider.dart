part of '../editorial_screen.dart';

class _SectionDivider extends StatefulWidget {
  const _SectionDivider(this.scrollNotifier, this.sectionNotifier,
      {super.key, required this.index});

  final int index;
  final ValueNotifier<double> scrollNotifier;
  final ValueNotifier<int> sectionNotifier;

  @override
  State<_SectionDivider> createState() => _SectionDividerState();
}

class _SectionDividerState extends State<_SectionDivider> {
  final _isActivated = ValueNotifier(false);

  double _getSwitchPt(BuildContext c) => c.heightPx * .5;

  void _checkPosition(BuildContext context) {
    final yPos = ContextUtils.getGlobalPos(context)?.dy;
    if (yPos == null || yPos < 0) return;

    bool activated = yPos < _getSwitchPt(context);
    if (activated != _isActivated.value) {
      scheduleMicrotask(() {
        int newIndex = activated ? widget.index : widget.index - 1;
        widget.sectionNotifier.value = newIndex;
      });
      _isActivated.value = activated;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Placeholder();
    return ValueListenableBuilder<double>(
        valueListenable: widget.scrollNotifier,
        builder: (context, value, _) {
          _checkPosition(context);
          return ValueListenableBuilder<bool>(
              valueListenable: _isActivated,
              builder: (_, value, __) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: $styles.instes.xl * 2),
                  child: CompassDivider(
                    isExpanded: value,
                  ),
                );
              });
        });
  }
}
