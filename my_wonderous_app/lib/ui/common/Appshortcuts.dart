import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Appshortcuts {
  static final Map<ShortcutActivator, Intent> _defaultWebAndDesktopShortcuts = <ShortcutActivator, Intent> {
    if (kIsWeb) ...{
      // On the web, enter activates buttons, but not other controls.
      const SingleActivator(LogicalKeyboardKey.enter): const ButtonActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.numpadEnter): const ButtonActivateIntent(),
    } else ...{
      const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.numpadEnter): const ActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.space): const ActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.gameButtonA): const ActivateIntent(),
    },

    // Dismissal
    const SingleActivator(LogicalKeyboardKey.escape): const DismissIntent(),

    // Keyboard traversal.
    const SingleActivator(LogicalKeyboardKey.tab): const NextFocusIntent(),
    const SingleActivator(LogicalKeyboardKey.tab, shift: true): const PreviousFocusIntent(),

    // Scrolling
    const SingleActivator(LogicalKeyboardKey.arrowUp): const ScrollIntent(direction: AxisDirection.up),
    const SingleActivator(LogicalKeyboardKey.arrowDown): const ScrollIntent(direction: AxisDirection.down),
    const SingleActivator(LogicalKeyboardKey.arrowLeft): const ScrollIntent(direction: AxisDirection.left),
    const SingleActivator(LogicalKeyboardKey.arrowRight): const ScrollIntent(direction: AxisDirection.right),
    const SingleActivator(LogicalKeyboardKey.pageUp):
    const  ScrollIntent(direction: AxisDirection.up, type: ScrollIncrementType.page),
    const  SingleActivator(LogicalKeyboardKey.pageDown):
    const ScrollIntent(direction: AxisDirection.down, type: ScrollIncrementType.page),
  };

  static Map<ShortcutActivator, Intent>? get defaults {
    return switch(defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.android => null,
    // unify shortcuts for desktop/web
      _ => _defaultWebAndDesktopShortcuts
    };

  }
}