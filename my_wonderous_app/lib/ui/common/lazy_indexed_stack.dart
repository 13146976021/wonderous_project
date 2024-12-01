import 'package:flutter/material.dart';


class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
        super.key,
        this.aligment = AlignmentDirectional.topStart,
        this.textDirection,
        this.sizing = StackFit.loose,
        this.index = 0,
        this.children = const []
  });

  final AlignmentGeometry aligment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final int index;
  final List<Widget> children;



  @override
  State<LazyIndexedStack> createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {


  List<bool> _initializeActivatedList() => List<bool>.generate(widget.children.length,(i) => i == widget.index);

  late List<bool> _activated = _initializeActivatedList();
  @override
  void didUpdateWidget(covariant LazyIndexedStack oldWidget) {
    if(oldWidget.children.length != widget.children.length){
      _activated = _initializeActivatedList();
}
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }


@override
  Widget build(BuildContext context) {
    _activated[widget.index] = true;
    final childern = List.generate(_activated.length,(i) {
      return _activated[i] ? widget.children[i] : const SizedBox.shrink();

  });
    return IndexedStack(
        alignment: widget.aligment,
        sizing: widget.sizing,
        textDirection: widget.textDirection,
        index:  widget.index,
        children: childern,
    );
  }
}
