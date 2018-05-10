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
import 'game_scene.dart';
import 'collision_ray.dart';
import 'projectile_game_object.dart';

abstract class AbstractGameObject extends Sprite implements Animatable {
  GameScene scene;

  AbstractGameObject(this.scene) {}

  Vector get position => new Vector(x, y);

  void set position(Vector value) {
    x = value.x;
    y = value.y;
  }

  bool collisionEnabled = false; // false to let players walk through

  bool visibleSolid = false; // true to hide objects behind object

  bool intersects(AbstractGameObject otherGameObject) {
    return collisionEnabled &&
      otherGameObject.collisionEnabled &&
      this.hitTestObject(
        otherGameObject);
  }

  List<Segment> getSegments() {
    Vector topLeft = new Vector(boundsTransformed.left, boundsTransformed.top);
    Vector topRight =
        new Vector(boundsTransformed.right, boundsTransformed.top);
    Vector bottomLeft =
        new Vector(boundsTransformed.left, boundsTransformed.bottom);
    Vector bottomRight =
        new Vector(boundsTransformed.right, boundsTransformed.bottom);

    Segment s1 = new Segment(topLeft, topRight);
    Segment s2 = new Segment(topRight, bottomRight);
    Segment s3 = new Segment(bottomLeft, bottomRight);
    Segment s4 = new Segment(topLeft, bottomLeft);

    return [s1, s2, s3, s4];
  }
  
  void onProjectileHit(ProjectileGameObject gameObject) {
  
  }

  @override
  bool advanceTime(num time) {
    return true;
  }
}
