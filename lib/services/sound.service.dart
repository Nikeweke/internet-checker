import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static Future<void> _playSound(String soundName) async {
    String audioPath = _audioPath(soundName);
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