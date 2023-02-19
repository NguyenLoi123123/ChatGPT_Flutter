enum StatusAudio { playing, stopped, paused, continued }

class ConfigAudio {
  static final ConfigAudio _instance = ConfigAudio._internal();

  factory ConfigAudio() {
    return _instance;
  }

  ConfigAudio._internal() {
    defaultSetting();
  }

  ///Âm lượng
  late double volumn;

  ///Độ cao
  late double pitch;

  ///Tốc độ
  late double rate;

  void defaultSetting() {
    volumn = 0.5;
    pitch = 0.8;
    rate = 0.5;
  }
}
