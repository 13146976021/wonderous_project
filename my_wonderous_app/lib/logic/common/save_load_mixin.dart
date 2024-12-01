
import 'package:flutter/cupertino.dart';
import 'package:wonders/logic/common/json_prefs_file.dart';
import 'package:wonders/logic/common/throttler.dart';

mixin ThrottledSaveLoadMixin {


  //封装第三方本地缓存
  late final _file = JsonPrefsFile(fileName);

  //模拟定时器
  final _throttle = Throttler(const Duration(seconds: 2));

  Future<void> load() async {
    final results = await _file.load();
    try{
      copyFromJson(results);

    }on Exception catch (e) {

      debugPrint(e.toString());
    }
  }

  Future<void> save() async {
    try {
      final results = await _file.save(toJson());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<void>scheduleSave() async => _throttle.call(save);


  String get fileName;
  void copyFromJson(Map<String, dynamic> value);
  Map<String, dynamic> toJson();

}