enum StatusAudio { playing, stopped, paused, continued }

class ConfigAudio {
  static final ConfigAudio _instance = ConfigAudio._internal();

  factory ConfigAudio() {
    return _instance;
  }

  ConfigAudio._internal() {
    defaultSetting();
  }

  late double volumn;
  late double pitch;
  late double rate;

  void defaultSetting() {
    volumn = 0.5;
    pitch = 1;
    rate = 0.5;
  }
}
