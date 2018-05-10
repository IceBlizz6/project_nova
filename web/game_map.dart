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
import 'game_loop.dart';
import 'game_scene.dart';

class GameMap extends DisplayObjectContainer {
  GameScene scene;
  BitmapData backgroundTex;
  
  double mapWidth = 2000.0;
  double mapHeight = 2000.0;
  
  Vector mapStart = new Vector(0, 0);
  Vector mapEnd = new Vector(2000, 2000);

  GameMap(this.scene) {
    backgroundTex = scene.loadBitmap("terrain1");

    Sprite background = new Sprite();
    background.addChild(new Bitmap(backgroundTex));
    background.width = mapWidth;
    background.height = mapHeight;

    this.addChild(background);
  }
}
