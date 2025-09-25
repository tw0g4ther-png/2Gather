import '../freezed/assetItem/itemOfassets.dart';
import '../utils/loader_ios.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoItem extends ConsumerStatefulWidget {
  final ItemOfAssets item;
  final VoidCallback clearAsset;
  const VideoItem({super.key, required this.item, required this.clearAsset});

  @override
  ConsumerState<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends ConsumerState<VideoItem> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  final int _ratioWidth = 9;
  final int _ratioHeight = 6;
  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _initVideo() async {
    var file = await widget.item.assetEntity.file;
    _videoPlayerController = VideoPlayerController.file(file!);
    await _videoPlayerController!.initialize();

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        showOptions: false,
        allowFullScreen: false,
        autoInitialize: false,
        showControlsOnInitialize: true,
        customControls: const CupertinoControls(
          backgroundColor: Colors.black,
          iconColor: Colors.white,
        ),
        fullScreenByDefault: false,
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final double scale;
    if (_videoPlayerController != null) {
      final aspectRatio = _ratioWidth / _ratioHeight;

      if (_videoPlayerController!.value.size.width >
          _videoPlayerController!.value.size.height) {
        scale =
            (1 / aspectRatio) *
            (_videoPlayerController!.value.size.width /
                _videoPlayerController!.value.size.height);
      } else {
        scale =
            (1 / aspectRatio) *
            (_videoPlayerController!.value.size.height /
                _videoPlayerController!.value.size.width);
      }

      return Stack(
        children: [
          _isLoading
              ? const Center(child: LoaderClassique())
              : Chewie(controller: _chewieController!),
          Positioned(
            top: 50.h,
            right: 20.w,
            child: IconButton(
              onPressed: widget.clearAsset,
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ],
      );
    } else {
      return const Center(child: LoaderClassique());
    }
  }
}
