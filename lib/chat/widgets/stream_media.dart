import 'dart:io';
import '../freezed/message/messageModel.dart';
import '../_mainn.dart';
import '../utils/loader_ios.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerChat extends StatefulWidget {
  final MessageModel messageModel;
  const VideoPlayerChat({super.key, required this.messageModel});

  @override
  VideoPlayerChatState createState() => VideoPlayerChatState();
}

class VideoPlayerChatState extends State<VideoPlayerChat> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (widget.messageModel.temporaryPath != null &&
        File(widget.messageModel.temporaryPath!).existsSync()) {
      _videoPlayerController = VideoPlayerController.file(
        File(widget.messageModel.temporaryPath!),
      );
      await _videoPlayerController!.initialize();
    } else {
      _videoPlayerController = await servicePlayer.getControllerForVideo(
        widget.messageModel.urlMediaContent!,
      );
      await _videoPlayerController!.initialize();
    }

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        showOptions: false,
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
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoPlayerController != null) {
      // Configuration de l'affichage vidéo

      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _isLoading
                ? const Center(child: LoaderClassique())
                : Chewie(controller: _chewieController!),
            Positioned(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [Colors.black, Colors.black],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        width: 47.w,
                        height: 47.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: Colors.white),
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const Scaffold(body: Center(child: LoaderClassique()));
    }
  }
}
