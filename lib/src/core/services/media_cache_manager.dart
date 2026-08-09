import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

bool isSvgMediaUrl(String mediaUrl) {
  final normalizedUrl = mediaUrl.trim().toLowerCase();
  final uriPath = Uri.tryParse(normalizedUrl)?.path.toLowerCase();
  if (uriPath?.endsWith('.svg') ?? false) {
    return true;
  }
  return normalizedUrl.split('?').first.endsWith('.svg');
}

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
        //16. Tap to fill
        if (content is TapToFillLessonContent) {
          _precacheTapToFillLessonContent(content, context);
        }
        //17. Option selection
        if (content is OptionSelectionLessonContent) {
          _precacheOptionSelectionLessonContent(content, context);
        }
        //18. Put in bag
        if (content is PutInBagLessonContent) {
          _precachePutInBagLessonContent(content, context);
        }
        //19. Tap the button
        if (content is TapTheButtonLessonContent) {
          _precacheTapTheButtonLessonContent(content, context);
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
      if (content.messageSound != null) {
        await _precacheMedia(content.messageSound!);
      }
      // Image
      if (content.bgImageMobile != null) {
        _precacheNetworkRasterImage(content.bgImageMobile!, context);
      }
      if (content.bgImageTablet != null) {
        _precacheNetworkRasterImage(content.bgImageTablet!, context);
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
        _precacheNetworkRasterImage(content.image, context);
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
        _precacheNetworkRasterImage(content.bgImage!, context);
      }
      if (content.successImage != null) {
        _precacheNetworkRasterImage(content.successImage!, context);
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
        _precacheNetworkRasterImage(content.bgImage!, context);
      }
      if (content.charImage != null && !content.isImageSvg) {
        _precacheNetworkRasterImage(content.charImage!, context);
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
      _precacheNetworkRasterImage(content.bgImage!, context);
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
        _precacheNetworkRasterImage(content.bgImageMobile!, context);
      }
      if (content.bgImageTablet != null) {
        _precacheNetworkRasterImage(content.bgImageTablet!, context);
      }
      if (content.player1 != null) {
        _precacheNetworkRasterImage(content.player1!, context);
      }
      if (content.player2 != null) {
        _precacheNetworkRasterImage(content.player2!, context);
      }
      if (content.ballImage != null) {
        _precacheNetworkRasterImage(content.ballImage!, context);
      }
      if (content.ballImageEnd != null) {
        _precacheNetworkRasterImage(content.ballImageEnd!, context);
      }
      if (content.goalLeftImageMb != null) {
        _precacheNetworkRasterImage(content.goalLeftImageMb!, context);
      }
      if (content.goalLeftImageTb != null) {
        _precacheNetworkRasterImage(content.goalLeftImageTb!, context);
      }
      if (content.goalRightImageMb != null) {
        _precacheNetworkRasterImage(content.goalRightImageMb!, context);
      }
      if (content.goalRightImageTb != null) {
        _precacheNetworkRasterImage(content.goalRightImageTb!, context);
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
      _precacheNetworkRasterImage(content.bgImage!, context);
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
      _precacheNetworkRasterImage(content.bgImage!, context);
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
      _precacheNetworkRasterImage(content.bgImage!, context);
    }
    if (content.bgImageTb != null) {
      _precacheNetworkRasterImage(content.bgImageTb!, context);
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
    _precacheNetworkRasterImage(content.bgImage, context);
    _precacheNetworkRasterImage(content.afterBgImage, context);

    _precacheNetworkRasterImage(content.bgImageTb, context);
    _precacheNetworkRasterImage(content.afterBgImageTb, context);
    for (var item in content.items) {
      _precacheItemMedia(item, context);
    }
    if (content.audio != null) {
      _precacheMedia(content.audio!);
    }
    if (content.tapGesture != null) {
      _precacheNetworkRasterImage(content.tapGesture!, context);
    }
    if (content.splashImage != null) {
      _precacheNetworkRasterImage(content.splashImage!, context);
    }
  }

  //16. Tap to fill
  _precacheTapToFillLessonContent(
    TapToFillLessonContent content,
    BuildContext context,
  ) {
    if (content.instruction != null) {
      _precacheMedia(content.instruction!);
    }
    if (content.audioBeforeOptions != null) {
      _precacheMedia(content.audioBeforeOptions!);
    }
    if (content.preBgImageMb != null) {
      _precacheNetworkRasterImage(content.preBgImageMb!, context);
    }
    if (content.preBgImageTb != null) {
      _precacheNetworkRasterImage(content.preBgImageTb!, context);
    }
    if (content.bgImage != null) {
      _precacheNetworkRasterImage(content.bgImage!, context);
    }
    if (content.bgImageTb != null) {
      _precacheNetworkRasterImage(content.bgImageTb!, context);
    }
  }

  //17. Option selection
  _precacheOptionSelectionLessonContent(
    OptionSelectionLessonContent content,
    BuildContext context,
  ) {
    if (content.instruction != null) {
      _precacheMedia(content.instruction!);
    }
    if (content.bgImage != null) {
      _precacheNetworkRasterImage(content.bgImage!, context);
    }
    if (content.bgImageTb != null) {
      _precacheNetworkRasterImage(content.bgImageTb!, context);
    }
    if (content.image != null) {
      _precacheNetworkRasterImage(content.image!, context);
    }
  }

  //18. Put in bag
  _precachePutInBagLessonContent(
    PutInBagLessonContent content,
    BuildContext context,
  ) {
    if (content.instructionAudio != null) {
      _precacheMedia(content.instructionAudio!);
    }
    if (content.bgImage != null) {
      _precacheNetworkRasterImage(content.bgImage!, context);
    }

    if (content.bgImageTb != null) {
      _precacheNetworkRasterImage(content.bgImageTb!, context);
    }
    if (content.bagImage != null) {
      _precacheNetworkRasterImage(content.bagImage!, context);
    }
    for (var item in content.items) {
      _precacheItemMedia(item, context);
    }
  }

  //19. Tap the button
  _precacheTapTheButtonLessonContent(
    TapTheButtonLessonContent content,
    BuildContext context,
  ) {
    if (content.bgImage != null) {
      _precacheNetworkRasterImage(content.bgImage!, context);
    }

    if (content.bgImageTb != null) {
      _precacheNetworkRasterImage(content.bgImageTb!, context);
    }
    if (content.buttonImage != null) {
      _precacheNetworkRasterImage(content.buttonImage!, context);
    }
    if (content.tapAudio != null) {
      _precacheMedia(content.tapAudio!);
    }
    if (content.instruction != null) {
      _precacheMedia(content.instruction!);
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
        _precacheNetworkRasterImage(item.imageOutline!, context);
      }
      if (!item.isImageSvg) {
        _precacheNetworkRasterImage(item.image, context);
      }
    } catch (e) {
      rethrow;
    }
  }

  void _precacheNetworkRasterImage(String imageUrl, BuildContext context) {
    if (isSvgMediaUrl(imageUrl)) {
      return;
    }
    precacheImage(CachedNetworkImageProvider(imageUrl), context);
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
