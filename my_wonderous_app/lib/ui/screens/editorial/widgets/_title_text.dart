part of '../editorial_screen.dart';

class _TitleText extends StatelessWidget {
  const _TitleText(this.data, {super.key, required this.scroller});
  final WonderData data;
  final ScrollController scroller;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: DefaultTextColor(
        color: $styles.colors.offWhite,
        child: Center(
          child: SizedBox(
            width: $styles.sizes.maxContentWidth1,
            child: Column(
              children: [
                Gap($styles.instes.md),
                Gap(30),
                 SeparatedRow(
                    padding: EdgeInsets.symmetric(horizontal: $styles.instes.sm),
                    separatorBuilder: () => Gap($styles.instes.sm),
                    children: [
                       Expanded(
                          child: Divider(
                            color: data.type.fgColor,
                          ).animate().scale(curve: Curves.easeOut, delay: 500.ms),
                      ),
                      Semantics(
                        header: true,
                        sortKey: OrdinalSortKey(1),
                        child: Text(
                          data.subTitle.toUpperCase(),
                          style: $styles.text.title2,
                        ).animate().fade(delay: 100.ms),
                      ),
                      Expanded(
                          child: Divider(
                            color: data.type.fgColor,
                          ).animate().scale(curve: Curves.easeOut, delay: 500.ms),
                      ),
                    ]
                 ),
                Gap($styles.instes.md),
                Semantics(
                  sortKey: OrdinalSortKey(0),
                  child: AnimatedBuilder(
                    animation: scroller,
                    builder: (_, __) {
                      final yPos = ContextUtils.getGlobalPos(context)?.dy ?? 0;
                      bool enableHero = false;
                      return WonderTitleText(data,enableHero: enableHero,);

                    },
                  ),
                ),
                Gap($styles.instes.xs),
                Text(
                  data.regionTitle.toUpperCase(),
                  style: $styles.text.title2,
                  textAlign: TextAlign.center,
                ),

                Gap($styles.instes.md),

                ExcludeSemantics(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: $styles.instes.sm),
                    child: AnimatedBuilder(
                      animation: scroller,
                      builder: (_, __) => CompassDivider(
                          isExpanded: scroller.position.pixels <= 0,
                          linesColor: data.type.fgColor,
                          compassColor: $styles.colors.offWhite,
                        ),
                    ),
                  ),
                ),
                Gap($styles.instes.sm),

                //公元前 多少年
                Text(
                  $strings.titleLabelDate(StringUtils.formatYr(data.startYr), StringUtils.formatYr(data.endYr)),
                  style: $styles.text.h4,
                  textAlign: TextAlign.center,
                ),
                Gap($styles.instes.sm),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
