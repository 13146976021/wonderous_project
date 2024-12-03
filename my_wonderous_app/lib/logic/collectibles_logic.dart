import 'package:wonders/logic/common/save_load_mixin.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/collectible_data.dart';

class CollectiblesLogic with ThrottledSaveLoadMixin  {
  String  get  fileName => 'collectibles.dat';

  final List<CollectibleData> all = collectiblesData;
  int _discoveredCount = 0;
  int get discoveredCount = _discoveredCount;
  int _exploredCount = 0;
  int get exploredCount => _exploredCount;

  late final stateById = ValueNotifier<Map<String, int>>({})..addListener(_)

  void _updateCounts() {
    _dis
  }


  @override
  void copyFromJson(Map<String, dynamic> value) {
    // TODO: implement copyFromJson
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }


}