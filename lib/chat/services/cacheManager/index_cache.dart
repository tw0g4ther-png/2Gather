import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

abstract class VideoControllerService {
  Future<VideoPlayerController> getControllerForVideo(String url);
}

class CachedVideoControllerService extends VideoControllerService {
  final BaseCacheManager _cacheManager;

  CachedVideoControllerService(this._cacheManager);

  @override
  Future<VideoPlayerController> getControllerForVideo(String url) async {
    final fileInfo = await _cacheManager.getFileFromCache(url);

    if (fileInfo == null) {
      debugPrint('[VideoControllerService]: No video in cache');

      debugPrint('[VideoControllerService]: Saving video to cache');
      _cacheManager.downloadFile(url);

      return VideoPlayerController.networkUrl(Uri.parse(url));
    } else {
      debugPrint('[VideoControllerService]: Loading video from cache');
      return VideoPlayerController.file(fileInfo.file);
    }
  }
}

class CustomCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 15),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}
