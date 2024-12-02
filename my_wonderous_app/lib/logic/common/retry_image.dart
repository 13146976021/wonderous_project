import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RetryImage extends ImageProvider<Object> {
  const RetryImage(this.imageProvider,{this.scale = 1.0, this.maxRetries = 4});

  final ImageProvider imageProvider;
  final int maxRetries;
  final double scale;

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    Completer<Object>? completer;
    SynchronousFuture<Object>? result;
    imageProvider.obtainKey(configuration).then((Object key){
      if(completer == null){
        result = SynchronousFuture<Object>(key);
      }else {
        completer.complete(key);
      }
    });

    if(result != null) {
      return result!;
    }

    completer = Completer<Object>();
    return completer.future;
  }

  @override
  ImageStreamCompleter loadImage(Object key, ImageDecoderCallback decode) {
    final _DelegatingImageSteamCompleter completer = _DelegatingImageSteamCompleter();
    ImageStreamCompleter completerToWrap = imageProvider.loadImage(key, decode);
    late ImageStreamListener listener;


    Duration duration = const Duration(milliseconds: 250);
    int count = 1;
    listener = ImageStreamListener(
            (ImageInfo image,bool synchronousCall) {
          completer.addImage(image);
        },
        onChunk: completer._reportChunkEvent,
        onError: (Object exception, StackTrace? stackTrac){
              completerToWrap.removeListener(listener);
              if(count > maxRetries) {
                completerToWrap.removeListener(listener);
                return;
              }

              Future<void>.delayed(duration).then((void v){
                duration *= 2;
                completerToWrap = imageProvider.loadImage(key, decode);
                count += 1;
                completerToWrap.addListener(listener);
              });
            }
            );

    completerToWrap.addListener(listener);
    completer.addOnLastListenerRemovedCallback((){
      completerToWrap.removeListener(listener);

    });

    return completer;

  }



  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is RetryImage && other.imageProvider == imageProvider && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(imageProvider, scale);



}




class _DelegatingImageSteamCompleter extends ImageStreamCompleter {
  void addImage(ImageInfo info){
    setImage(info);
  }

  void _reportChunkEvent(ImageChunkEvent event) {
    reportImageChunkEvent(event);
  }
}