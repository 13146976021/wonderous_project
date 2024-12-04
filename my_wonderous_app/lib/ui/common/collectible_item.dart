import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/collectibles_logic.dart';
import 'package:wonders/logic/data/collectible_data.dart';
import 'package:wonders/ui/common/opening_card.dart';

class CollectibleItem extends StatelessWidget with GetItMixin{
  CollectibleItem({super.key, required this.collectible, required this.size,  this.focus}) {
    _imageProvider = NetworkImage(collectible.imageUrl);
    _imageProvider.resolve(ImageConfiguration()).addListener(ImageStreamListener((_, __){}));

  }
  final CollectibleData collectible;
  final double size;
  late final ImageProvider _imageProvider;
  final FocusNode? focus;

  void _handleTap(BuildContext context) async {
  }

  @override
  Widget build(BuildContext context) {
    final states = watchX((CollectiblesLogic c) => c.stateById);
    bool isLost = states[collectible.id] == CollectibleState.lost;



    return SizedBox(
      height: isLost ? size : null,
      child:  RepaintBoundary(
        child:  OpeningCard(
            isOpen: isLost,
            closedBuilder: (_) => SizedBox(width: 1,height: 0,),
            openBuilder: (_) => AppBtn.basic(
              focusNode: focus,
              semanticLabel: $strings.collectibleItemSemanticCollectible,
              onPressed: () => _handleTap(context),
              enableFeedback: false,
              child: Hero(
                tag: 'collectible_icon_${collectible.id}',
                child: Image(
                  image: collectible.icon,
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(delay: 4000.ms,duration: $styles.times.med * 3)
              .shake(curve: Curves.easeInOutCubic, hz:4)
              .scale(begin: Offset(1.0, 1.0),end:  Offset(1.1, 1.1),duration: $styles.times.med)
              .then(delay: $styles.times.med)
              .scale(begin: Offset(1.0, 1.0),end: Offset(1 / 1.1, 1 / 1.1)),
            ),
            ),
      ),
    );
  }
}
