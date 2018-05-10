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
import 'game_object_components/render_component.dart';

class GamePhysicsObject extends AbstractGameObject {
  double maxSpeed = 5.0;
  Vector acceleration = new Vector(0, 0);
  Vector velocity = new Vector(0, 0);

  GamePhysicsObject(GameScene scene, RenderComponent renderComponent) : super(scene, renderComponent) {}

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
    
    position += scene.checkBounds(this);

    return super.advanceTime(time);
  }
}
