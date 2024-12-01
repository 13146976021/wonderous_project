import 'dart:io';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wonders/common_libs.dart';
import 'package:wonders/logic/data/wonder_data.dart';
import 'package:wonders/logic/unsplash_service.dart';
import 'package:wonders/logic/wonders_logic.dart';

class UnsplashDownloadService {
  static final UnsplashService _unsplash = UnsplashService();
  static final WondersLogic _wondersLogic = WondersLogic();


  static Future<int> downloadImageSet(String id) async {
    final photo = await _unsplash.loadInfo(id);
    int saveCount = 0;
    if(photo != null) {
      final rootDir = await getApplicationDocumentsDirectory();
      final imageDir = '${rootDir.path}/unsplash_images';
      await Directory(imageDir).create(recursive:  true);
      debugPrint("Downloading image set $id to $imageDir");
      final sizes = [32, 400, 800, 2000, 1600, 4000];
      for(var size in sizes) {
        final url = photo.getUnsplashUrl(size);
        final imgResponse = await get(Uri.parse(url));
        File file = File('$imageDir/$id-$size.jpg');
        file.writeAsBytesSync(imgResponse.bodyBytes);
        saveCount++;

      }
    }
    return saveCount;
  }

  static Future<void> downloadCollectionImages(WonderData data) async {
    final collection = await _unsplash.loadCollectionPhotos(data.unsplashCollectionId) ?? [];
    debugPrint('download:${collection.length} images for ${data.title}');
    int donwloadCount = 0;
    for(var p in collection) {
      donwloadCount += await downloadImageSet(p);

    }

    debugPrint('${data.title} complete.downloads = $donwloadCount');

  }

  static Future<void> downloadAllCollections() async {
    for(var w in _wondersLogic.all) {
      await downloadCollectionImages(w);
    }
  }


  static Future<void>printPhotosbyCollectionIdMap() async {

  }
}