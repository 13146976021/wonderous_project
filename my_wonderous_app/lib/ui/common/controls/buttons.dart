import 'package:flutter/material.dart';
import 'package:wonders/main.dart';

class AppBtn extends StatelessWidget {
  AppBtn({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.child,
    this.padding,
    this.expand =false,
    this.isSecondary = false,
    this.circular = false,
    this.minimumSize,
    this.bgColor,
    this.border,
    this.focusNode,
    this.onFocusChanged
  }) : _builder = null;


  //交互
  final VoidCallback? onPressed;
  late final String semanticLabel;
  final bool enableFeedback;
  final FocusNode? focusNode;
  final void Function(bool hasFocus)? onFocusChanged;


  //content
  late final Widget? child;
  late final WidgetBuilder? _builder;

  //布局:
  final EdgeInsets? padding;
  final bool expand;
  final circular;
  final Size? minimumSize;

  //样式
  final bool isSecondary;
  final BorderSide? border;
  final Color? bgColor;
  final bool pressEffect;






  @override
  Widget build(BuildContext context) {
    Color defaultColor = isSecondary ? $styles.colors.white : $styles.colors.greyStrong;
    Color textColor = isSecondary ? $styles.colors.black : $styles.colors.white;
    BorderSide side = border ?? BorderSide.none;

    Widget content = _builder?.call(context) ?? child ?? SizedBox.shrink();

    if(expand) content = Center(child: content);

    OutlinedBorder shape = circular
    ? CircleBorder(side: side)
    : RoundedRectangleBorder(side: side,borderRadius: BorderRadius.circular($styles.corners.md));

    ButtonStyle style = ButtonStyle(
    minimumSize: ButtonStyleButton.allOrNull(minimumSize ?? Size.zero),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    splashFactory: NoSplash.splashFactory,
    backgroundColor: ButtonStyleButton.allOrNull<Color>(bgColor ?? defaultColor),
    overlayColor:ButtonStyleButton.allOrNull<Color>(Colors.transparent),
    shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
    padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding ?? EdgeInsets.all($styles.instes.md)),
    enableFeedback: enableFeedback
    );


    Widget button = _CustomFocusBuilder(
      focusNode: focusNode,
      onFocusChanged: onFocusChanged,
      builder: (context, focus) => Stack(
        children: [
          Opacity(
            opacity: onPressed == null ? 0.5 : 1.0,
            child: TextButton(
                onPressed: onPressed,
                style: style,
                focusNode: focus,
                child: DefaultTextStyle(
                    style: DefaultTextStyle.of(context).style.copyWith(color: textColor),
                    child: content
                ),
            ),
          ),
          if(focus.hasFocus)
            Positioned.fill(
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular($styles.corners.md),
                      border: Border.all(color: $styles.colors.accent1,width: 3)
                    ),
                  ),
                )
            )
        ],

      ),
    );

    if(pressEffect && onPressed != null) button = _ButtonPressEffect(button);
    if(semanticLabel.isEmpty) return button;
    return Semantics(
      label: semanticLabel,
      button: true,
      container: true,
      child: ExcludeSemantics(child: button,),
    );
  }
}
class _ButtonPressEffect extends StatefulWidget {
  const _ButtonPressEffect(
      this.child
      );
  final Widget child;


  @override
  State<_ButtonPressEffect> createState() => _ButtonPressEffectState();
}

class _ButtonPressEffectState extends State<_ButtonPressEffect> {
  bool _isDown = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      excludeFromSemantics: true,
      onTapDown: (_) => setState(() => _isDown = true),
      onTapUp: (_) => setState(() => _isDown = false),
      onTapCancel: () => setState(() => _isDown = false),
      behavior: HitTestBehavior.translucent,
      child: Opacity(
          opacity: _isDown ? 0.7 : 1,
        child: ExcludeSemantics(child: widget.child,),
      ),
    );
  }
}


class _CustomFocusBuilder extends StatefulWidget {
  const _CustomFocusBuilder({
    super.key,
    required this.builder,
    this.focusNode,
    required this.onFocusChanged,

  });
  final Widget Function(BuildContext context, FocusNode focus) builder;
  // final void Function(bool hasFocus)? onFocusChanged;
  final void Function(bool hasFocus)? onFocusChanged;

  final FocusNode? focusNode;


  @override
  State<_CustomFocusBuilder> createState() => _CustomFocusBuilderState();
}

class _CustomFocusBuilderState extends State<_CustomFocusBuilder> {
  late final FocusNode _focusNode;


  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);

    super.initState();
  }

  void _handleFocusChanged() {
    widget.onFocusChanged?.call(_focusNode.hasFocus);
    if(mounted) {
      setState(() {
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context, _focusNode);
  }

}

