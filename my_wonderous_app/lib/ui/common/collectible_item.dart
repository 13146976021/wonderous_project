import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/collectible_data.dart';

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
    return Container(
      color: Colors.red,
      child: Center(
        child: Text("333"),
      ),
    );
  }
}
