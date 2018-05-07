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
import 'abstract_game_object.dart';
import 'game_scene.dart';

class GamePhysicsObject extends AbstractGameObject {
  double maxSpeed = 5.0;
  Vector acceleration = new Vector(0, 0);
  Vector velocity = new Vector(0, 0);

  GamePhysicsObject(GameScene scene) : super(scene) {}

  @override
  bool advanceTime(num time) {
    velocity += acceleration.scale(time);

    if (velocity.length > maxSpeed) {
      velocity = velocity.normalize().scale(maxSpeed);
    }

    Vector targetPosition = position + velocity;

    position = scene.checkCollisionMovement(
        this, position, new Vector(targetPosition.x, position.y));

    position = scene.checkCollisionMovement(
        this, position, new Vector(position.x, targetPosition.y));

    x = Math.max(0, x);

    if (super.boundsTransformed.left < 0) {
      double displace = -super.boundsTransformed.left;
      x += displace;
    }

    if (super.boundsTransformed.right > 1280) {
      double displace = super.boundsTransformed.right - 1280;
      x -= displace;
    }

    if (super.boundsTransformed.top < 0) {
      double displace = -super.boundsTransformed.top;
      y += displace;
    }

    if (super.boundsTransformed.bottom > 720) {
      double displace = super.boundsTransformed.bottom - 720;
      y -= displace;
    }

    return super.advanceTime(time);
  }
}
