part of '../editorial_screen.dart';
class _LargeSimpleQuotete extends StatelessWidget {
  const _LargeSimpleQuotete({super.key, required this.text, required this.author});
  final String text;
  final String author;


  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: CenteredBox(
        width: 300,
        // padding: EdgeInsets.symmetric(horizontal: $styles.instes.lg),
        child: Column(
          children: [
            FractionalTranslation(
                translation: Offset(0, 0.5),
                child: Text(
                  '“',
                  style: $styles.text.quote1.copyWith(
                    color: $styles.colors.accent1,
                    fontSize: 90 * $styles.scale,
                    height: .7
                  ),
                ),
            ),
            Text(text,style: $styles.text.quote2,textAlign: TextAlign.center),
            Gap($styles.instes.md),
            Text('- $author',style: $styles.text.quote2Sub.copyWith(color: $styles.colors.accent1),),
          ],
        ),
      ),
    );
  }
}
