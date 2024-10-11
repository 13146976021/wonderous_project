

import 'package:flutter/cupertino.dart';
import 'package:wonders/logic/common/platform_info.dart';
import 'package:wonders/logic/common/save_load_mixin.dart';

class SettingsLogic with ThrottledSaveLoadMixin {


  @override
  String get fileName => 'setting.dart';


  late final hasCompletedOnboarding = ValueNotifier<bool>(false)..addListener(scheduleSave);
  late final hasDismissedSearchMessage = ValueNotifier<bool>(false)..addListener(scheduleSave);
  late final isSearchPanelOpen = ValueNotifier<bool>(true)..addListener(scheduleSave);
  late final currentLocale = ValueNotifier<String?>(null)..addListener(scheduleSave);
  late final prevWonderIndex = ValueNotifier<int?>(null)..addListener(scheduleSave);

  final bool useBlurs = !PlatformInfo.isAndroid;

  Future<void> changeLocale(Locale value) async {
    currentLocale.value = value.languageCode;
  }




  @override
  void copyFromJson(Map<String, dynamic> value) {
    hasCompletedOnboarding.value = value['hasCompletedOnboarding'] ?? false;
    hasDismissedSearchMessage.value = value['hasDismissedSearchMessage'] ?? false;
    currentLocale.value = value['currentLocale'];
    isSearchPanelOpen.value = value['isSearchPanelOpen'] ?? false;
    prevWonderIndex.value = value['lastWonderIndex'];
  }



  @override
  Map<String, dynamic> toJson() {
    return {
      'hasCompletedOnboarding': hasCompletedOnboarding.value,
      'hasDismissedSearchMessage': hasDismissedSearchMessage.value,
      'currentLocale': currentLocale.value,
      'isSearchPanelOpen': isSearchPanelOpen.value,
      'lastWonderIndex': prevWonderIndex.value,
    };

  }


}