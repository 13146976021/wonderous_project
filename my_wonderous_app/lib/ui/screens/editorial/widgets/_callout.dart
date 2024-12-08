part of '../editorial_screen.dart';

class _Callout extends StatelessWidget {
  const _Callout(this.text, {super.key});
  final String text;



  @override
  Widget build(BuildContext context) {

    debugPrint('$text');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(color: $styles.colors.accent1,width: 1,),
          Gap($styles.instes.sm),
          Expanded(
              child: Text(
                text,
                style: $styles.text.callout,
              )
          ),
        ],
      ),
    );
  }
}
