class Assets {
  /// [Brand] assets
  static String logo = 'logo'.png;
  static String placeholder = 'placeholder'.jpg;
  static String userAvatar = 'user_avatar'.png;
  static String patternBg = 'pattern_bg'.png;

  /// [Lottie] assets
  static String logoLottie = 'onepali'.lottie;
  static String bgTransition = 'bg_transition'.gif;

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

  /// [Remark] assets
  static String goodRemark = 'good_cat'.remark;

  /// [Home] Menu
  static String games = 'game'.icon;
  static String stories = 'story'.icon;
  static String songsRhymes = 'song'.icon;
  static String lessons = 'lesson'.icon;

  /// [Json] assets
  static String user = 'user'.json;
  static String lessonJson = 'lesson'.json;

  /// [Audio] assets
  static String eww = 'audio/eww'.audio;
}

extension AssetsExtension on String {
  String get png => 'assets/images/$this.png';
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
