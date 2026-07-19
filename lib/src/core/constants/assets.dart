import 'package:flutter/material.dart';
import '../core.dart';

class Assets {
  /// [Brand] assets
  static String logo = 'logo'.png;
  static String logoSvg = 'logo_svg'.brandSvg;
  static String leoSvg = 'leo'.brandSvg;
  static String placeholder = 'placeholder'.jpg;
  static String userAvatar = 'user_avatar'.png;
  static String parentAvatar = 'parent_avatar'.png;
  static String blueUserAvatar = 'blue_avatar'.png;

  static String patternBg = 'pattern_bg'.png;
  static String rewardBackground = 'reward_bg'.png;
  static String rewardPreviewBackground = 'reward_preview_bg'.png;
  static String notificationOn = 'notification_on'.png;
  static String leoChracterSvg = 'leo_character'.brandSvg;

  // Seal
  static String kidSafeSeal = 'kid_safe_seal'.png;

  /// [Image] assets
  static String splashImage = 'splash'.gif;
  static String mbSplashImage = 'mb_splash'.mp4;
  static String tbSplashImage = 'tb_splash'.mp4;

  /// [Parent] Zone assets
  static String parentZoneImage = 'pz_danfe'.png;
  static String parentHome = 'pz_home'.parentSvg;
  static String parentBlog = 'pz_blog'.parentSvg;
  static String parentSetting = 'pz_setting'.parentSvg;

  /// [Avatar] assets
  static String avatar1 = 'av_1'.avatar;
  static String avatar2 = 'av_2'.avatar;
  static String avatar3 = 'av_3'.avatar;
  static String avatar4 = 'av_4'.avatar;
  static String avatar5 = 'av_5'.avatar;
  static String avatar6 = 'av_6'.avatar;
  static String avatar7 = 'av_7'.avatar;
  static String avatar8 = 'av_8'.avatar;

  /// [Lottie] assets
  static String logoLottie = 'onepali'.lottie;
  static String leoCharacterLottie = 'leo_character'.lottie;
  static String successLottie = 'success'.lottie;
  static String successLottie1 = 'success1'.lottie;
  static String logoutLottie = 'hand_weaving'.lottie;
  static String preLoader = 'pre_loader'.lottie;
  static String starRewardLottie = 'rewards_star'.lottie;
  static String starWinnerLottie = 'stars_winner'.lottie;
  static String alarmExtendLottie = 'alarm_extend'.lottie;
  static String completeConfettiLottie = 'complete_confetti'.lottie;
  static String confetti1 = 'confetti_1'.lottie;
  static String confetti2 = 'confetti_2'.lottie;
  static String noInternetLottie = 'no_internet_found'.lottie;
  static String lessonSuccessLottie = 'lesson_success_confetti'.lottie;

  /// [Icons] assets
  static String rightArrow = 'right_arrow'.icon;
  static String leftArrow = 'left_arrow'.icon;
  static String downArrow = 'down_arrow'.icon;
  static String upArrow = 'up_arrow'.icon;
  static String speak = 'speak'.icon;
  static String wrong = 'wrong'.icon;
  static String closeGreyIcon = 'close_grey_btn'.icon;
  static String check = 'check'.icon;
  static String tick = 'tick'.icon;
  static String correct = 'correct'.icon;
  static String sound = 'sound'.icon;
  static String sound1 = 'sound1'.icon;
  static String play = 'play'.icon;
  static String redo = 'redo'.icon;
  static String meta = 'meta'.icon;
  static String youtube = 'youtube'.icon;
  static String other = 'other'.icon;
  static String google = 'google'.icon;
  static String blog = 'blog'.icon;
  static String apple = 'apple'.icon;
  static String facebook = 'facebook'.icon;
  static String search = 'search'.icon;
  static String reward = 'reward'.icon;
  static String family = 'family'.icon;
  static String home = 'home'.icon;
  static String logout = 'logout'.icon;
  static String scrollRightArrow = 'scroll_right_arrow'.icon;
  static String star = 'star'.icon;
  static String unsubscribe = 'unfav'.icon;
  static String email = 'email'.icon;

  ///[ Buttons] assets
  static String checkButton = "check_btn".buttonSvg;

  /// [Miscellaneous]
  static String successSvg = 'success'.svg;
  static String childSuccessSvg = 'child_onboard'.svg;
  static String logoutSvg = 'logout'.svg;
  static String profileUpdateSvg = 'profile_update'.svg;
  static String dataSvg = 'data'.svg;
  static String connectionSvg = 'connection'.svg;
  static String timeUpSvg = 'time_up'.svg;
  static String guestAvatar = 'guest_avatar'.svg;
  static String trophyAv = 'trophy'.png;
  static String medalAv = 'medal'.png;
  static String starAv = 'star'.png;
  static String achievement = 'achievement'.png;
  static String achievementTab = 'achievement_tab'.png;
  static String rocket = 'rocket'.svg;

  /// [Remark] assets
  static String goodRemark = 'good_cat'.remark;
  static String goodRemark1 = 'good_cat1'.remark;

  /// [Home] Menu
  static String games = 'game'.icon;
  static String stories = 'story'.icon;
  static String songsRhymes = 'song'.icon;
  static String lessons = 'lesson'.icon;

  /// [Home] --> [Drawer] assets
  static String profile = 'profile'.icon;
  static String setting = 'setting'.icon;
  static String parentZone = 'parent'.icon;
  static String download = 'download'.icon;

  /// Get drawer icon path based on device type (w24 for mobile, w32 for tablet)
  static String getDrawerIcon(BuildContext context, String baseName) {
    final isTablet = PlatformUtility.isTablet(context);
    return isTablet
        ? 'assets/svg/icons/${baseName}_tablet.svg'
        : 'assets/svg/icons/$baseName.svg';
  }

  /// Drawer icons with device-aware selection
  static String homeIcon(BuildContext context) =>
      getDrawerIcon(context, 'home');
  static String familyIcon(BuildContext context) =>
      getDrawerIcon(context, 'family');
  static String logoutIcon(BuildContext context) =>
      getDrawerIcon(context, 'logout');
  static String downloadIcon(BuildContext context) =>
      getDrawerIcon(context, 'download');
  static String parentZoneIcon(BuildContext context) =>
      getDrawerIcon(context, 'parent');

  /// [Json] assets
  // static String user = 'user'.json;
  // static String lessonJson = 'lesson'.json;

  /// [Localization] assets
  static String enJson = 'en'.json;
  static String neJson = 'ne'.json;

  /// [Audio] assets
  static String eww = 'audio/sfx/eww'.audio;
  static String wrongSfx = 'audio/sfx/wrong'.audio;
  static String goodFeedback = 'audio/sfx/good_feedback'.audio;
  static String confettiFeedback = 'audio/sfx/confetti_feedback'.audio;
  static String starBlast = 'audio/sfx/star_blast.mp3';
  static String cardFlip = 'audio/sfx/card_flip'.audio;
}

extension AssetsExtension on String {
  String get brandSvg => 'assets/brand/$this.svg';
  String get brandPng => 'assets/brand/$this.png';
  String get png => 'assets/images/$this.png';
  String get avatar => 'assets/images/avatar/$this.png';
  String get remark => 'assets/images/remark/$this.png';
  String get jpg => 'assets/images/$this.jpg';
  String get jpeg => 'assets/images/$this.jpeg';
  String get gif => 'assets/images/$this.gif';
  String get webp => 'assets/images/$this.webp';
  String get svg => 'assets/svg/$this.svg';
  String get icon => 'assets/svg/icons/$this.svg';
  String get parentSvg => 'assets/svg/parent/$this.svg';
  String get lottie => 'assets/lottie/$this.json';
  String get audio => '$this.mp3';
  String get mp4 => 'assets/images/$this.mp4';
  String get json => 'assets/json/$this.json';
  String get buttonSvg => 'assets/svg/buttons/$this.svg';
}
