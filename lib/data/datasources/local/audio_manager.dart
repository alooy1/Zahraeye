import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../presentation/providers/game_providers.dart';

// Cinematic sound - using local files from zahraeye-work
class CinematicSounds {
  static const String mainTheme = 'audio/music/app sound.mp3';
  // Local SFX sounds
  static const String click = 'audio/sfx/in.mp3';
  static const String win = 'audio/sfx/win.mp3';
  // Keep URL sounds for other SFX
  static const String success = 'https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3';
  static const String fail = 'https://www.soundjay.com/misc/sounds/error-01.mp3';
}

class AudioManager {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  bool _isMuted = false;
  double _musicVolume = 0.7;
  double _sfxVolume = 0.8;
  bool _isInitialized = false;
  bool _isPlayingMusic = false;

  AudioManager() {
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      _isInitialized = true;
      debugPrint('AudioManager initialized');
    } catch (e) {
      debugPrint('Audio init error: $e');
    }
  }

  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    _musicPlayer.setVolume(_musicVolume);
  }

  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    _sfxPlayer.setVolume(_sfxVolume);
  }

  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      _musicPlayer.setVolume(0);
      _sfxPlayer.setVolume(0);
      _musicPlayer.stop();
    } else {
      _musicPlayer.setVolume(_musicVolume);
      _sfxPlayer.setVolume(_sfxVolume);
    }
  }

  Future<void> playMusic([String trackName = 'main']) async {
    if (_isMuted) return;

    try {
      // Stop current music first
      await _musicPlayer.stop();
      await _musicPlayer.setVolume(_musicVolume);

      // Play local music file from assets
      await _musicPlayer.play(AssetSource(CinematicSounds.mainTheme));
      debugPrint('Playing app background music');
    } catch (e) {
      debugPrint('Error playing music: $e');
    }
  }

  Future<void> stopMusic() async {
    try {
      await _musicPlayer.stop();
      _isPlayingMusic = false;
    } catch (e) {
      debugPrint('Error stopping music: $e');
    }
  }

  Future<void> pauseMusic() async {
    await _musicPlayer.pause();
  }

  Future<void> resumeMusic() async {
    await _musicPlayer.resume();
  }

  Future<void> playSfx(String soundName) async {
    if (_isMuted) return;

    try {
      await _sfxPlayer.setVolume(_sfxVolume);

      // Use local assets for click and win
      if (soundName == 'click' || soundName == 'win') {
        String assetPath = soundName == 'click' ? CinematicSounds.click : CinematicSounds.win;
        await _sfxPlayer.stop();
        await _sfxPlayer.play(AssetSource(assetPath));
      } else {
        // Use URL for other sounds
        String url;
        switch (soundName) {
          case 'success':
            url = CinematicSounds.success;
            break;
          case 'fail':
            url = CinematicSounds.fail;
            break;
          default:
            url = CinematicSounds.click;
        }
        await _sfxPlayer.stop();
        await _sfxPlayer.setSource(UrlSource(url));
        await _sfxPlayer.resume();
      }
      debugPrint('Playing SFX: $soundName');
    } catch (e) {
      debugPrint('Error playing SFX: $e');
    }
  }

  // Predefined sound methods
  Future<void> playClick() async => playSfx('click');
  Future<void> playSuccess() async => playSfx('success');
  Future<void> playFail() async => playSfx('fail');
  Future<void> playUnlock() async => playSfx('unlock');
  Future<void> playTransition() async => playSfx('transition');
  Future<void> playVictory() async => playSfx('victory');

  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }
}

// Provider for audio manager
final audioManagerProvider = Provider<AudioManager>((ref) {
  final manager = AudioManager();

  // Listen to audio settings changes
  ref.listen(audioSettingsProvider, (previous, next) {
    manager.setMusicVolume(next.musicVolume);
    manager.setSfxVolume(next.sfxVolume);
    manager.setMuted(!next.musicEnabled || !next.sfxEnabled);
  });

  ref.onDispose(() {
    manager.dispose();
  });

  return manager;
});