import 'package:wonders/logic/common/save_load_mixin.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/collectible_data.dart';
import 'package:wonders/logic/native_widget_service.dart';

class CollectiblesLogic with ThrottledSaveLoadMixin  {
  String  get  fileName => 'collectibles.dat';

  final List<CollectibleData> all = collectiblesData;

  late final stateById = ValueNotifier<Map<String, int>>({})..addListener(_updateCounts);


  int _discoveredCount = 0;
  int get discoveredCount => _discoveredCount;
  int _exploredCount = 0;
  int get exploredCount => _exploredCount;

  late final _nativeWidget = GetIt.I<NativeWidgetService>();
  void init() => _nativeWidget.init();


  CollectibleData? fromId(String? id) => id == null ? null : all.firstWhereOrNull((o) => o.id == id);


  List<CollectibleData> forWonder(WonderType wonder) {
    return all.where((o) => o.wonder == wonder).toList(growable: false);
  }


  void setState(String id, int state) {
    Map<String ,int> states = Map.of(stateById.value);
    states[id] = state;
    stateById.value = states;
    if(state == CollectibleState.discovered) {
      final data = fromId(id)!;
      _updateNativeHomeWidgetData(
        title: data.title,
        id: data.id,
        imageUrl: data.imageUrl
      );
    }

    scheduleSave();

  }


  Future<void> _updateNativeHomeWidgetData({String title = '', String id = '', String imageUrl = ''}) async {
    if(_nativeWidget.isSupported) return;
    await _nativeWidget.save('lastDiscoveredTitle', title);

    String subTitle = '';
    if(id.isNotEmpty) {
      // final artifactData = await artifact
    }
  }


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