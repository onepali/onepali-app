class Assets {
  /// [Brand] assets
  static String logo = 'logo'.png;
  static String logoSvg = 'logo_svg'.brandSvg;
  static String leoSvg = 'leo'.brandSvg;
  static String placeholder = 'placeholder'.jpg;
  static String userAvatar = 'user_avatar'.png;
  static String patternBg = 'pattern_bg'.png;
  static String leoChracterSvg = 'leo_character'.brandSvg;

  /// [Image] assets
  static String splashImage = 'splash'.gif;

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
  static String bgTransition = 'bg_transition'.gif;
  static String successLottie = 'success'.lottie;

  /// [Icons] assets
  static String rightArrow = 'right_arrow'.icon;
  static String leftArrow = 'left_arrow'.icon;
  static String downArrow = 'down_arrow'.icon;
  static String upArrow = 'up_arrow'.icon;
  static String speak = 'speak'.icon;
  static String wrong = 'wrong'.icon;
  static String check = 'check'.icon;
  static String sound = 'sound'.icon;
  static String play = 'play'.icon;
  static String redo = 'redo'.icon;
  static String meta = 'meta'.icon;
  static String youtube = 'youtube'.icon;
  static String other = 'other'.icon;
  static String family = 'family'.icon;
  static String google = 'google'.icon;
  static String blog = 'blog'.icon;
  static String facebook = 'facebook'.icon;

  // Miscellaneous
  static String successSvg = 'success'.svg;
  static String childSuccessSvg = 'child_onboard'.svg;
  static String logout = 'logout'.svg;

  /// [Remark] assets
  static String goodRemark = 'good_cat'.remark;

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

  /// [Json] assets
  static String user = 'user'.json;
  static String lessonJson = 'lesson'.json;

  /// [Localization] assets
  static String enJson = 'en'.json;
  static String neJson = 'ne'.json;

  /// [Audio] assets
  static String eww = 'audio/eww'.audio;
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
  String get lottie => 'assets/lottie/$this.json';
  String get audio => '$this.mp3';
  String get json => 'assets/json/$this.json';
}
