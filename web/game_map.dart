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
import 'package:box2d/box2d.dart' as box2d;
import 'static_game_object.dart';
import 'game_object_components/box_collision_component.dart';

class GameMap extends DisplayObjectContainer {
  GameScene scene;
  BitmapData backgroundTex;
  
  double mapWidth = 2000.0;
  double mapHeight = 2000.0;
  
  Vector mapStart = new Vector(0, 0);
  Vector mapEnd = new Vector(2000, 2000);
  
  StaticGameObject gameObj;

  GameMap(this.scene, box2d.World world) {
    backgroundTex = scene.loadBitmap("terrain1");

    Sprite background = new Sprite();
    background.addChild(new Bitmap(backgroundTex));
    background.width = mapWidth;
    background.height = mapHeight;

    this.addChild(background);
    
    this.gameObj = new StaticGameObject(this.scene, null);
    
    createWall(world, mapWidth, 1.0, 0.0, -1.0); // Top wall
    createWall(world, mapWidth, 1.0, 0.0, mapHeight); // bot wall
    createWall(world, 1.0, mapHeight, -1.0, 0.0); // left wall
    createWall(world, 1.0, mapHeight, mapWidth, 0.0); // right wall
  }
  
  void createWall(box2d.World world, double width, double height, double posX, double posY) {
    double scale = BoxCollisionComponent.globalMultiplier;
    
    box2d.BodyDef def = new box2d.BodyDef();
    def.type = box2d.BodyType.STATIC;

    box2d.PolygonShape shape = new box2d.PolygonShape();
    shape.setAsBoxXY(width * scale, height * scale);

    box2d.Body body = world.createBody(def);

    box2d.Fixture fixture = body.createFixtureFromShape(shape);
    fixture.userData = gameObj;
    
    body.setTransform(new box2d.Vector2(posX * scale, posY * scale), 0.0);
  }
}
