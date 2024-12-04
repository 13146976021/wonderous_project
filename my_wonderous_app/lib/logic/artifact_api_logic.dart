
import 'dart:async';
import 'dart:collection';

import 'package:get_it/get_it.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/artiface_api_service.dart';
import 'package:wonders/logic/data/artifact_data.dart';
import 'package:wonders/logic/http_client.dart';

class ArtifactAPILogic {
  final HashMap<String, ArtifactData?> _artifactCache = HashMap();

  ArtifaceApiService get service => GetIt.I.get<ArtifaceApiService>();
  Future<ArtifactData?> getArtifaceByID(String id, {bool selfHosted = false}) async {
    if(_artifactCache.containsKey(id)) return _artifactCache[id];
    ServiceResult<ArtifactData?> result =
    (await(selfHosted ? service.getSelfHostedObjectByID(id) : service.getMetObjectByID(id)));
    if(!result.success) throw $strings.artifactDetailsErrorNotFound(id);
    ArtifactData? artifact = result.content;
    return _artifactCache[id] = artifact;
  }
}