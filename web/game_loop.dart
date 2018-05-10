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
import 'game_socket.dart';
import 'network_object.dart';
import 'game_scene.dart';

class GameLoop implements Animatable {
  ResourceManager resourceManager;
  GameSocket gameSocket;
  KeyboardDevice keyboardDevice;
  MouseDevice mouseDevice;
  GamepadDevice gamepadDevice;
  Stage _stage;
  GameScene gameScene;

  GameLoop(this.resourceManager, this._stage) {
    this.keyboardDevice = new KeyboardDevice();
    _stage.juggler.add(keyboardDevice);

    this.mouseDevice = new MouseDevice();
    _stage.juggler.add(mouseDevice);

    this.gamepadDevice = new GamepadDevice(0);
    _stage.juggler.add(gamepadDevice);

    //this.gameSocket = new GameSocket(this);

    this.gameScene = new GameScene(this, resourceManager);
    _stage.addChild(gameScene);
    _stage.juggler.add(gameScene);
  }

  @override
  bool advanceTime(num time) {
    return true;
  }
  
  void addJuggler(Animatable animatable) {
    _stage.juggler.add(animatable);
  }
  
  void removeJuggler(Animatable animatable) {
    _stage.juggler.remove(animatable);
  }

  void updateNetwork() {}

  void updateRemoveNetwork(String removeId) {}
}
