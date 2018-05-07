import 'abstract_game_object.dart';
import 'dart:html';
import 'game_scene.dart';
import 'keyboard_device.dart';
import 'mouse_device.dart';
import 'game_physics_object.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:math' as Math;
import 'gamepad_device.dart';

class ControllableGameObject extends GamePhysicsObject {
  KeyboardDevice keyboardDevice;
  MouseDevice mouseDevice;
  GamepadDevice gamepadDevice;
  bool inputMode;

  ControllableGameObject(GameScene scene, this.keyboardDevice, this.mouseDevice,
      this.gamepadDevice)
      : super(scene) {}

  @override
  bool advanceTime(num time) {
    acceleration = new Vector(0, 0);
    double accelerationPower = 20.0;

    //double val =
    //double stickX = gamepadDevice.stickValue(0, 0);
    //double stickY = gamepadDevice.stickValue(0, 1);
    //acceleration += new Vector(stickX, stickY);
    //querySelector('#text').text = gamepadDevice.stickValue(0, 0).toString() + ", " + gamepadDevice.stickValue(0, 1).toString();

    if (keyboardDevice.isDown(KeyCode.W)) {
      acceleration += new Vector(0, -1);
    }

    if (keyboardDevice.isDown(KeyCode.S)) {
      acceleration += new Vector(0, 1);
    }

    if (keyboardDevice.isDown(KeyCode.A)) {
      acceleration += new Vector(-1, 0);
    }

    if (keyboardDevice.isDown(KeyCode.D)) {
      acceleration += new Vector(1, 0);
    }

    acceleration = acceleration.scale(accelerationPower);

    num velX = velocity.x;
    num velY = velocity.y;

    if (acceleration.x == 0) {
      velX += -velX * 0.1;
    }
    if (acceleration.y == 0) {
      velY += -velY * 0.1;
    }

    velocity = new Vector(velX, velY);

    num mouseX = stage.mouseX;
    num mouseY = stage.mouseY;
    Vector dir = new Vector(mouseX - x, mouseY - y).normalize();
    num rotValue = ((dir.degrees - 90) / 180) * Math.PI;
    rotation = rotValue;

    super.advanceTime(time);
  }
}
