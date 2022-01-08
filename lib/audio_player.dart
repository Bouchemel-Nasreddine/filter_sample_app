
import 'package:audioplayers/audioplayers.dart';

class Player extends AudioPlayer{
  static final Player _player = Player._internal();

  factory Player() {
    return _player;
  }

  Player._internal();


}