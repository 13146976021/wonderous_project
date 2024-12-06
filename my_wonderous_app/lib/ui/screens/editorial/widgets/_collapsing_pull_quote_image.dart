part of '../editorial_screen.dart';
class _CollapsingPullQuoteImage extends StatelessWidget {
  const _CollapsingPullQuoteImage({super.key, required this.scrollPos, required this.data});
  final ValueNotifier<double> scrollPos;
  final WonderData data;


  @override
  Widget build(BuildContext context) {
    const double outerPadding = 100;
    const double imgHeight = 500;
    final collapseStartPx = context.heightPx * 1;
    final collapseEndPx = context.heightPx * .15;



    Widget buildText(String value, double collapseAmt,{required bool top, bool isAuthor = false}) {


      var quoteStyle = $styles.text.quote1.copyWith(fontSize: 32);
      quoteStyle = quoteStyle.copyWith(color: $styles.colors.caption);
      if (isAuthor) {
        quoteStyle = quoteStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w600);
      }
      double offsetY = (imgHeight / 2 + outerPadding * .25) * (1 - collapseAmt);
      if(top) offsetY *= -1;
      debugPrint(' offsetY =  $offsetY');
      return Transform.translate(
          offset: Offset(0, offsetY),
          child: Text(value, style: quoteStyle,textAlign: TextAlign.center)
      );

    }

    return ValueListenableBuilder(
        valueListenable: scrollPos,
        builder: (context,value, _) {
          double collapseAmt = 1.0;

          final yPos = ContextUtils.getGlobalPos(context)?.dy;
          if(yPos != null && yPos < collapseStartPx) {
            collapseAmt = (collapseStartPx - max(collapseEndPx, yPos)) / (collapseStartPx - collapseEndPx);

          }

      return  CenteredBox(
          padding: const EdgeInsets.symmetric(vertical: outerPadding),
          width: imgHeight * .55,
          child: Stack(
            children: [
              //背景
              Container(
                  width: context.widthPx,
                  height: imgHeight,
                  decoration: BoxDecoration(
                      border: Border.all(color: $styles.colors.accent1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(context.widthPx / 2),
                        topLeft: Radius.circular(context.widthPx / 2),
                      )
                  )
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: imgHeight,
                    child:

                        Container(
                          alignment: Alignment.topRight,
                          margin: EdgeInsets.all(12),
                          child: ClipPath(
                            clipper: CurvedTopClipper(),
                            child: _buildImage(collapseAmt),
                          ),
                    ),

                  )
                ],
              ),


              Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: BlendMask(
                      blendModes: [BlendMode.colorBurn],
                      child: StaticTextScale(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 32,),
                            buildText(data.pullQuote1Top, collapseAmt, top: true),
                            buildText(data.pullQuote1Bottom, collapseAmt, top: false),

                            if(data.pullQuote1Author.isNotEmpty) ... [
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                child: buildText('- ${data.pullQuote1Author}', collapseAmt, top: false, isAuthor: true),

                              )
                            ]
                          ],
                        ),

                    ),),
                  )
              )


            ],
          )
      );
    });


  }


  Widget _buildImage(double collapseAmt) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ScalingListItem(
            scrollpos: scrollPos,
            child: Image.asset(
              data.type.photo2,
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(1 - collapseAmt * .7),

            )
        ),

        GradientContainer([
          Color(0xFFBEABA1).withOpacity(1),
          Color(0xFFA6958C).withOpacity(1),
        ], const [0.0, 1.0],
        blendMode: BlendMode.colorBurn,)
      ],
    );
  }
}
