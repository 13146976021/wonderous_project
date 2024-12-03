import 'package:wonders/logic/common/save_load_mixin.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/collectible_data.dart';
import 'package:wonders/logic/native_widget_service.dart';

class CollectiblesLogic with ThrottledSaveLoadMixin  {
  String  get  fileName => 'collectibles.dat';

  final List<CollectibleData> all = collectiblesData;
  int _discoveredCount = 0;
  int get discoveredCount => _discoveredCount;
  int _exploredCount = 0;
  int get exploredCount => _exploredCount;

  late final _nativeWidget = GetIt.I<NativeWidgetService>();
  void init() => _nativeWidget.init();



  late final stateById = ValueNotifier<Map<String, int>>({})..addListener(_updateCounts);


  void _updateCounts() {
    _discoveredCount = _exploredCount = 0;
    stateById.value.forEach((_, state){
      if(state == CollectibleState.discovered) _discoveredCount++;
      if(state == CollectibleState.explored) _exploredCount++;

    });

    final foundCount = discoveredCount + exploredCount;

    _nativeWidget.save<int>('discoveredCount', foundCount).then((value){_nativeWidget.markDirty();});

    debugPrint('setting discoveredCount for home widget $foundCount');


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