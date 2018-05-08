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
import 'game_physics_object.dart';
import 'game_socket.dart';
import 'network_object.dart';
import 'game_scene.dart';

class GameLoop implements Animatable {
  ResourceManager resourceManager;
  GameSocket gameSocket;
  KeyboardDevice keyboardDevice;
  MouseDevice mouseDevice;
  GamepadDevice gamepadDevice;
  Stage stage;
  GameScene gameScene;

  GameLoop(this.resourceManager, this.stage) {
    this.keyboardDevice = new KeyboardDevice();
    stage.juggler.add(keyboardDevice);

    this.mouseDevice = new MouseDevice();
    stage.juggler.add(mouseDevice);

    this.gamepadDevice = new GamepadDevice(0);
    stage.juggler.add(gamepadDevice);

    //this.gameSocket = new GameSocket(this);

    this.gameScene = new GameScene(this, resourceManager);
  }

  @override
  bool advanceTime(num time) {
    return true;
  }

  void updateNetwork() {}

  void updateRemoveNetwork(String removeId) {}
}
