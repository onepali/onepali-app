class Assets {
  /// [Brand] assets
  static String logo = 'logo'.png;
  static String placeholder = 'placeholder'.jpg;
  static String userAvatar = 'user_avatar'.png;
  static String patternBg = 'pattern_bg'.png;

  /// Lottie assets
  static String logoLottie = 'onepali'.lottie;

  /// [Icons] assets
  static String rightArrow = 'right_arrow'.icon;
  static String leftArrow = 'left_arrow'.icon;
  static String downArrow = 'down_arrow'.icon;
  static String upArrow = 'up_arrow'.icon;
  static String check = 'check'.icon;
  static String close = 'close'.icon;
  static String sound = 'sound'.icon;

  /// [Json] assets
  static String user = 'user'.json;
  static String lessons = 'lesson'.json;
}

extension AssetsExtension on String {
  String get png => 'assets/images/$this.png';
  String get jpg => 'assets/images/$this.jpg';
  String get jpeg => 'assets/images/$this.jpeg';
  String get webp => 'assets/images/$this.webp';
  String get svg => 'assets/svg/$this.svg';
  String get icon => 'assets/svg/icons/$this.svg';
  String get lottie => 'assets/lottie/$this.json';
  String get audio => 'assets/audio/$this.mp3';
  String get json => 'assets/json/$this.json';
}
