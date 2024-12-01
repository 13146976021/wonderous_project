import 'package:wonders/common_libs.dart';
import 'package:wonders/styles/wonders_color_extensions.dart';
import 'package:wonders/ui/common/controls/circle_buttons.dart';
class WonderDetailsTabMenu extends StatelessWidget {
  static const double buttonInset = 12;
  static const double homeBtnSize = 74;
  static const double minTabSize = 25;
  static const double maxTabSize = 100;


  const WonderDetailsTabMenu({
    super.key,
    required this.tabController,
    this.showBg = false,
    required this.wonderType,
    this.axis = Axis.horizontal,
    required this.onTap,
  });

  final TabController tabController;
  final bool showBg;
  final WonderType wonderType;
  final Axis axis;

  bool get isVertical => axis == Axis.vertical;
  final void Function(int index) onTap;







  @override
  Widget build(BuildContext context) {
    Color iconColor = showBg ? $styles.colors.black : $styles.colors.white;
    final availableSize = (isVertical ? context.heightPx : context.widthPx) - homeBtnSize - $styles.instes.md;

    final double tabBtnSize = (availableSize / 4).clamp(minTabSize  , maxTabSize);
    final double gapAmt = max(0, tabBtnSize - homeBtnSize);
    final double safeAreaBtn = context.mq.padding.bottom , safeAreaTop = context.mq.padding.top;
    final buttonInsetPadding = isVertical ? EdgeInsets.only(right: buttonInset) : EdgeInsets.only(top: buttonInset);



    return Padding(
        padding: isVertical? EdgeInsets.only(top: safeAreaTop) : EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
                child: Padding(
                  padding: buttonInsetPadding,
                  child: AnimatedOpacity(
                    duration: $styles.times.fast,
                    opacity: showBg ? 1 : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: $styles.colors.white,
                        borderRadius: isVertical ? BorderRadius.only(topRight: Radius.circular(32)) : null,
                      ),
                    ),
                  ),
                )
            ),
            Padding(
                padding: EdgeInsets.only(bottom: isVertical ? 0 : safeAreaBtn),
              child: SizedBox(
                width: isVertical ? null : double.infinity,
                height: isVertical ? double.infinity : null,
                child: FocusTraversalGroup(
                  child: Flex(
                    direction: axis,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(

                        child: Padding(
                            padding: isVertical
                                ? EdgeInsets.only(left: $styles.instes.xs)
                                : EdgeInsets.only(bottom: $styles.instes.xs),
                          child: _WonderHomeBtn(
                            size: homeBtnSize,
                            wonderType: wonderType,
                            borderSize: showBg ? 6 : 2,

                          ),
                        ),
                      ),
                      Gap(gapAmt),
                      Padding(
                          padding: buttonInsetPadding,
                          child: Flex(
                            direction: axis,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _TabBtn(
                                0,
                                tabController,
                                iconImg: 'editorial',
                                label: $strings.wonderDetailsTabLabelInformation,
                                color: iconColor,
                                axis: axis,
                                mainaxisSize: tabBtnSize,
                                onTap: onTap,
                              ),

                              _TabBtn(
                                1,
                                tabController,
                                iconImg: 'photos',
                                label: $strings.wonderDetailsTabLabelInformation,
                                color: iconColor,
                                axis: axis,
                                mainaxisSize: tabBtnSize,
                                onTap: onTap,
                              ),

                              _TabBtn(
                                2,
                                tabController,
                                iconImg: 'artifacts',
                                label: $strings.wonderDetailsTabLabelInformation,
                                color: iconColor,
                                axis: axis,
                                mainaxisSize: tabBtnSize,
                                onTap: onTap,
                              ),

                              _TabBtn(
                                3,
                                tabController,
                                iconImg: 'timeline',
                                label: $strings.wonderDetailsTabLabelInformation,
                                color: iconColor,
                                axis: axis,
                                mainaxisSize: tabBtnSize,
                                onTap: onTap,
                              ),
                            ],
                          ),
                      )
                    ],

                  ),

                ),

              ),
            ),

          ],
        ),
    );
  }
}


class _WonderHomeBtn extends StatelessWidget {
  const _WonderHomeBtn({
    super.key,
    required this.size,
    required this.wonderType,
    required this.borderSize
  });
  final double size;
  final WonderType wonderType;
  final double borderSize;


  @override
  Widget build(BuildContext context) {
    return CircleBtn(
        onPressed: () => context.go(ScreenPaths.home),
        semanticLabel: $strings.wonderDetailsTabSemanticBack,
        bgColor: $styles.colors.white,
        child: AnimatedContainer(
          curve: Curves.easeOut,
          duration: $styles.times.fast,
          width: size - borderSize * 2,
          height: size - borderSize * 2,
          margin: EdgeInsets.all(borderSize),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            color: wonderType.fgColor,
            image: DecorationImage(
              image: AssetImage(wonderType.homeBtn),
              fit: BoxFit.fill
            )
          ),

        ) ,
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn(
  this.index,
  this.tabController,
  {
    required this.iconImg,
    required this.color,
    required this.label,
    required this.axis,
    required this.mainaxisSize,
    required this.onTap
  });

  static const double scrossBtnSize = 0;
  final int index;
  final TabController tabController;
  final String iconImg;
  final Color color;
  final String label;
  final Axis axis;
  final double mainaxisSize;
  final void Function(int index) onTap;


  bool get _isVertical => axis == Axis.vertical;


  @override
  Widget build(BuildContext context) {

    bool selected = tabController.index == index;
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final iconImgPath = '${ImagePaths.common}/tab-$iconImg${selected ? '-active' : ''}.png';

    String tabLabel = localizations.tabLabel(tabIndex: index + 1, tabCount: tabController.length);
    tabLabel = '$label : $tabLabel';
    final double iconSize = min(mainaxisSize, 32);

    return MergeSemantics(
      child: Semantics(
        selected: selected,
        label: tabLabel,
      child: ExcludeSemantics(
          child:  AppBtn.basic(
          onPressed: () => onTap(index),
          semanticLabel: label,
          minimumSize:  _isVertical ? Size(scrossBtnSize, mainaxisSize) : Size(mainaxisSize, scrossBtnSize),
          child:  Image.asset(
          iconImgPath,
          height: iconSize,
          width: iconSize,
          color: selected ? null : color,
          ),
        ),
      ),
    ),
    );
  }
}


