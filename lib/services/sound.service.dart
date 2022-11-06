import 'package:audioplayers/audioplayers.dart';
import 'package:internet_checker/services/shared_prefs.service.dart';

class SoundService {
  static Future<void> _playSound(String soundName) async {
    String audioPath = _audioPath(soundName);

    if (SharedPrefs.isDisabledSounds()) {
      return;
    }

    AudioPlayer().play(AssetSource(audioPath));
  }

  static String _audioPath(String soundName) {
    return 'audio/$soundName.wav';
  }

  static void playGoodSound() {
    _playSound('good');
  }

  static void playSadSound() {
    _playSound('bad');
  }
}