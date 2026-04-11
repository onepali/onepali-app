import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class MediaCacheManager {
  static const key = 'mediaCache';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30), // Cache for 30 days
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );

  void cacheLessonMedia(List<LessonContent> contents, BuildContext context) {
    try {
      for (var content in contents) {
        //1. Intro lesson content
        if (content is IntroLessonContent) {
          _precacheIntroLessonContent(content, context);
        }
        //2.Info
        if (content is InfoLessonContent) {
          _precacheInfoLessonContent(content, context);
        }
        //3.Choose correct
        if (content is ChooseCorrectLessonContent) {
          _precacheChooseCorrectLessonContent(content, context);
        }
        //4.Tap to reveal
        if (content is TapToRevealLessonContent) {
          _precacheTapToRevealLessonContent(content, context);
        }
        //5.Drag to match
        if (content is DragToMatchLessonContent) {
          _precacheDragToMatchLessonContent(content, context);
        }
        //6.Tap to pop
        if (content is TapToPopLessonContent) {
          _precacheTapToPopLessonContent(content, context);
        }
        //7.Listen and repeat
        if (content is ListenAndRepeatLessonContent) {
          _precacheListenAndRepeatLessonContent(content, context);
        }
        //8.Char tracing
        if (content is CharTracingLessonContent) {
          _precacheCharTracingLessonContent(content, context);
        }
        //9.Tea making
        // if (content is TeaMakingLessonContent) {
        //   _precacheTeaMakingLessonContent(content, context);
        // }
        //10.Ball slide
        if (content is BallSlideLessonContent) {
          _precacheBallSlideLessonContent(content, context);
        }
        //11.Slide up to match
        if (content is SlideUpToMatchLessonContent) {
          _precacheSlideUpToMatchLessonContent(content, context);
        }
        //12.Flip card
        if (content is FlipCardLessonContent) {
          _precacheFlipCardLessonContent(content, context);
        }
        //13.Balloon fill
        if (content is BalloonFillLessonContent) {
          _precacheBalloonFillLessonContent(content, context);
        }
        //14. Gun fill
        if (content is GunFillLessonContent) {
          _precacheGunFillLessonContent(content, context);
        }
        //15. Tap to change
        if (content is TapToChangeLessonContent) {
          _precacheTapToChangeLessonContent(content, context);
        }
      }
    } catch (e) {
      log('Error pre caching medias: $e');
    }
  }

  // -----------------------Helper methods-----------------------

  //1.Intro lesson content
  _precacheIntroLessonContent(
    IntroLessonContent content,
    BuildContext context,
  ) async {
    try {
      // Audio
      if (content.audio != null) {
        await _precacheMedia(content.audio!);
      }
      if (content.bgImageMobile != null) {
        precacheImage(
          CachedNetworkImageProvider(content.bgImageMobile!),
          context,
        );
      }
      if (content.bgImageTablet != null) {
        precacheImage(
          CachedNetworkImageProvider(content.bgImageTablet!),
          context,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  //2.Info lesson content
  _precacheInfoLessonContent(InfoLessonContent content, BuildContext context) {
    try {
      // Audio
      _precacheMedia(content.audioWord);
      if (content.audioBg != null) {
        _precacheMedia(content.audioBg!);
      }
      if (content.video != null) {
        _precacheMedia(content.video!);
      }
      if (!content.isImageSvg) {
        precacheImage(CachedNetworkImageProvider(content.image), context);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 3.Choose correct
  _precacheChooseCorrectLessonContent(
    ChooseCorrectLessonContent content,
    BuildContext context,
  ) {
    try {
      for (var item in content.items) {
        _precacheItemMedia(item, context);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 4.Tap to reveal
  _precacheTapToRevealLessonContent(
    TapToRevealLessonContent content,
    BuildContext context,
  ) {
    try {
      for (var item in content.items) {
        _precacheItemMedia(item, context);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 5.Drag to match
  _precacheDragToMatchLessonContent(
    DragToMatchLessonContent content,
    BuildContext context,
  ) {
    try {
      for (var item in content.items) {
        _precacheItemMedia(item, context);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 6.Tap to pop
  _precacheTapToPopLessonContent(
    TapToPopLessonContent content,
    BuildContext context,
  ) {
    try {
      if (content.audioWord != null) {
        _precacheMedia(content.audioWord!);
      }
      if (content.instructionAudio != null) {
        _precacheMedia(content.instructionAudio!);
      }
      if (content.bgImage != null) {
        precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
      }
      if (content.successImage != null) {
        precacheImage(
          CachedNetworkImageProvider(content.successImage!),
          context,
        );
      }
      for (var item in content.items) {
        _precacheItemMedia(item, context);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 7.Listen and repeat
  _precacheListenAndRepeatLessonContent(
    ListenAndRepeatLessonContent content,
    BuildContext context,
  ) {
    try {
      _precacheMedia(content.audioWord);
      if (content.audioBg != null) {
        _precacheMedia(content.audioBg!);
      }
      if (content.bgImage != null) {
        precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
      }
      if (content.charImage != null && !content.isImageSvg) {
        precacheImage(CachedNetworkImageProvider(content.charImage!), context);
      }
    } catch (e) {
      rethrow;
    }
  }

  // 8.Char tracing
  _precacheCharTracingLessonContent(
    CharTracingLessonContent content,
    BuildContext context,
  ) {
    if (content.bgImage != null) {
      precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
    }
  }

  // 9.Tea making
  // _precacheTeaMakingLessonContent(
  //   TeaMakingLessonContent content,
  //   BuildContext context,
  // ) {
  //   if (content.bgImage != null) {
  //     precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
  //   }
  // }

  // 10.Ball slide
  _precacheBallSlideLessonContent(
    BallSlideLessonContent content,
    BuildContext context,
  ) async {
    try {
      // Audios
      for (var audio in content.conversation) {
        await DefaultCacheManager().getSingleFile(audio);
      }
      if (content.bgImageMobile != null) {
        precacheImage(
          CachedNetworkImageProvider(content.bgImageMobile!),
          context,
        );
      }
      if (content.bgImageTablet != null) {
        precacheImage(
          CachedNetworkImageProvider(content.bgImageTablet!),
          context,
        );
      }
      if (content.player1 != null) {
        precacheImage(CachedNetworkImageProvider(content.player1!), context);
      }
      if (content.player2 != null) {
        precacheImage(CachedNetworkImageProvider(content.player2!), context);
      }
      if (content.ballImage != null) {
        precacheImage(CachedNetworkImageProvider(content.ballImage!), context);
      }
      if (content.ballImageEnd != null) {
        precacheImage(
          CachedNetworkImageProvider(content.ballImageEnd!),
          context,
        );
      }
      if (content.goalLeftImageMb != null) {
        precacheImage(
          CachedNetworkImageProvider(content.goalLeftImageMb!),
          context,
        );
      }
      if (content.goalLeftImageTb != null) {
        precacheImage(
          CachedNetworkImageProvider(content.goalLeftImageTb!),
          context,
        );
      }
      if (content.goalRightImageMb != null) {
        precacheImage(
          CachedNetworkImageProvider(content.goalRightImageMb!),
          context,
        );
      }
      if (content.goalRightImageTb != null) {
        precacheImage(
          CachedNetworkImageProvider(content.goalRightImageTb!),
          context,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // 11.Slide up to match
  _precacheSlideUpToMatchLessonContent(
    SlideUpToMatchLessonContent content,
    BuildContext context,
  ) {
    if (content.bgImage != null) {
      precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
    }
    for (var item in content.items) {
      _precacheItemMedia(item, context);
    }
  }

  // 12.Flip card
  _precacheFlipCardLessonContent(
    FlipCardLessonContent content,
    BuildContext context,
  ) {
    if (content.bgImage != null) {
      precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
    }
    for (var item in content.items) {
      _precacheItemMedia(item, context);
    }
  }

  // 13. Balloon fill
  _precacheBalloonFillLessonContent(
    BalloonFillLessonContent content,
    BuildContext context,
  ) {
    if (content.audio != null) {
      _precacheMedia(content.audio!);
    }
    if (content.bgImage != null) {
      precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
    }
    if (content.bgImageTb != null) {
      precacheImage(CachedNetworkImageProvider(content.bgImageTb!), context);
    }
    for (var item in content.items) {
      _precacheItemMedia(item, context);
    }
  }

  // 14. Gun fill
  _precacheGunFillLessonContent(
    GunFillLessonContent content,
    BuildContext context,
  ) {
    if (content.bgImage != null) {
      _precacheMedia(content.bgImage!);
    }
    if (content.bgImageTb != null) {
      _precacheMedia(content.bgImageTb!);
    }
    if (content.audio != null) {
      _precacheMedia(content.audio!);
    }

    for (var item in content.items) {
      _precacheItemMedia(item, context);
    }
  }

  // 15. Tap to change
  _precacheTapToChangeLessonContent(
    TapToChangeLessonContent content,
    BuildContext context,
  ) {
    precacheImage(CachedNetworkImageProvider(content.bgImage), context);
    precacheImage(CachedNetworkImageProvider(content.afterBgImage), context);

    precacheImage(CachedNetworkImageProvider(content.bgImageTb), context);
    precacheImage(CachedNetworkImageProvider(content.afterBgImageTb), context);
    for (var item in content.items) {
      _precacheItemMedia(item, context);
    }
    if (content.audio != null) {
      _precacheMedia(content.audio!);
    }
    if (content.tapGesture != null) {
      precacheImage(CachedNetworkImageProvider(content.tapGesture!), context);
    }
    if (content.splashImage != null) {
      precacheImage(CachedNetworkImageProvider(content.splashImage!), context);
    }
  }

  // Item images
  _precacheItemMedia(Item item, BuildContext context) {
    try {
      // Audios and videos
      if (item.audioItem != null) {
        _precacheMedia(item.audioItem!);
      }
      if (item.audioBg != null) {
        _precacheMedia(item.audioBg!);
      }
      if (item.question != null) {
        _precacheMedia(item.question!);
      }
      // Images
      if (item.imageOutline != null && !item.isImageOutlineSvg) {
        precacheImage(CachedNetworkImageProvider(item.imageOutline!), context);
      }
      if (!item.isImageSvg) {
        final image = item.image;
        final extension = image.split('.').last;
        if (extension == 'svg') {
          return;
        }
        precacheImage(CachedNetworkImageProvider(image), context);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Cache audio and video
  _precacheMedia(String audioUrl) async {
    try {
      await DefaultCacheManager().getSingleFile(audioUrl);
    } catch (e) {
      rethrow;
    }
  }
}
