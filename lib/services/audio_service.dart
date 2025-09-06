import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _effectsPlayer = AudioPlayer();

  factory AudioService() => _instance;

  AudioService._internal();

  Future<void> playBackgroundMusic(String path, {double volume = 0.5}) async {
    await _backgroundPlayer.stop();
    await _backgroundPlayer.setSource(AssetSource(path));
    await _backgroundPlayer.setVolume(volume);
    await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
    await _backgroundPlayer.resume();
  }

  Future<void> playSoundEffect(String path, {double volume = 0.7}) async {
    await _effectsPlayer.stop();
    await _effectsPlayer.setSource(AssetSource(path));
    await _effectsPlayer.setVolume(volume);
    await _effectsPlayer.resume();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundPlayer.stop();
  }

  Future<void> setBackgroundVolume(double volume) async {
    await _backgroundPlayer.setVolume(volume);
  }

  Future<void> dispose() async {
    await _backgroundPlayer.dispose();
    await _effectsPlayer.dispose();
  }
}