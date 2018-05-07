import 'dart:async';
import 'dart:html' as html;
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'keyboard_device.dart';
import 'gamepad_device.dart';
import 'dart:math';
import 'game_camera.dart';
import 'dart:math' as Math;
import 'mouse_device.dart';

class NetworkObject extends Sprite implements Animatable {
  double reportX;
  double reportY;
  double reportRotation;

  Vector get position => new Vector(x, y);

  void set position(Vector value) {
    x = value.x;
    y = value.y;
  }

  @override
  bool advanceTime(num time) {
    x = reportX;
    y = reportY;
    rotation = reportRotation;
  }
}
