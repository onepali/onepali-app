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

  void cacheLessonImages(List<LessonContent> contents, BuildContext context) {
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
    }
  }

  // -----------------------Helper methods-----------------------

  //1.Intro lesson content
  _precacheIntroLessonContent(
    IntroLessonContent content,
    BuildContext context,
  ) {
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
  }

  //2.Info lesson content
  _precacheInfoLessonContent(InfoLessonContent content, BuildContext context) {
    if (!content.isImageSvg) {
      precacheImage(CachedNetworkImageProvider(content.image), context);
    }
  }

  // 3.Choose correct
  _precacheChooseCorrectLessonContent(
    ChooseCorrectLessonContent content,
    BuildContext context,
  ) {
    for (var item in content.items) {
      _precacheItemImages(item, context);
    }
  }

  // 4.Tap to reveal
  _precacheTapToRevealLessonContent(
    TapToRevealLessonContent content,
    BuildContext context,
  ) {
    for (var item in content.items) {
      _precacheItemImages(item, context);
    }
  }

  // 5.Drag to match
  _precacheDragToMatchLessonContent(
    DragToMatchLessonContent content,
    BuildContext context,
  ) {
    for (var item in content.items) {
      _precacheItemImages(item, context);
    }
  }

  // 6.Tap to pop
  _precacheTapToPopLessonContent(
    TapToPopLessonContent content,
    BuildContext context,
  ) {
    if (content.bgImage != null) {
      precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
    }
    if (content.successImage != null) {
      precacheImage(CachedNetworkImageProvider(content.successImage!), context);
    }
    for (var item in content.items) {
      _precacheItemImages(item, context);
    }
  }

  // 7.Listen and repeat
  _precacheListenAndRepeatLessonContent(
    ListenAndRepeatLessonContent content,
    BuildContext context,
  ) {
    if (content.bgImage != null) {
      precacheImage(CachedNetworkImageProvider(content.bgImage!), context);
    }
    if (content.charImage != null && !content.isImageSvg) {
      precacheImage(CachedNetworkImageProvider(content.charImage!), context);
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
  ) {
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
      _precacheItemImages(item, context);
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
      _precacheItemImages(item, context);
    }
  }

  // Item images
  _precacheItemImages(Item item, BuildContext context) {
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
  }
}
