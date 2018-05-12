import 'abstract_game_object.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:math' as Math;
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
import 'controllable_game_object.dart';
import 'main.dart';
import 'game_map.dart';
import 'collision_ray.dart';
import 'package:stagexl/stagexl.dart' as StageXL;
import 'projectile_game_object.dart';
import 'game_object_components/full_render_component.dart';
import 'game_object_components/partial_render_component.dart';
import 'package:box2d/box2d.dart' as box2d;
import 'static_game_object.dart';
import 'game_object_components/custom_contact_listener.dart';
import 'game_object_components/custom_contact_filter.dart';
import 'game_object_type.dart';

class GameScene extends DisplayObjectContainer implements Animatable {
  GameLoop _gameLoop;
  ResourceManager resourceManager;
  List<AbstractGameObject> gameObjects;
  ControllableGameObject playerObject;
  // Map<String, NetworkObject> networkSprites = new Map<String, NetworkObject>();
  GameCamera camera;

  StageXL.Shape wireShape;

  box2d.World world;

  GameMap gameMap;

  BitmapData laserBitmapData;

  GameScene(this._gameLoop, this.resourceManager) {
    this.world = new box2d.World.withGravity(new box2d.Vector2(0.0, 0.0));
		world.setContactListener(new CustomContactListener());
		world.setContactFilter(new CustomContactFilter());
    
    this.laserBitmapData = loadBitmap("laser1");
    
    gameObjects = new List<AbstractGameObject>();

		this.gameMap = new GameMap(this, world);
    
    this.camera = new GameCamera(gameMap, _gameLoop.keyboardDevice);
    this.addChild(camera);
    _gameLoop.addJuggler(camera);
    
    camera.addChild(gameMap);
    
    
    setupPlayerObject(new Vector(700, 200));
    addBox(new Vector(400, 300), new Vector(0.5, 2.0));

		addBox(new Vector(100, 800), new Vector(4.0, 1.0));
    addShipVisibility();
    
    
    camera.target = playerObject;

    this.wireShape = new StageXL.Shape();
    this.addChild(wireShape);
  }

  @override
  bool advanceTime(num time) {
    List<Segment> segments = getAllSegments();
    List<IntersectionData> polygons =
        CollisionRay.getSightPolygon(segments, playerObject.position);

    var matrix = camera.globalTransformationMatrix;
    List<Vector> pList = polygons.map((el) => matrix.transformVector(el.v)).toList();
    drawTest(wireShape.graphics, pList, matrix.transformVector(playerObject.position));

    world.stepDt(time, 10, 10);

    var destroyList = gameObjects.where((el) => el.gameObjectType == GameObjectType.PROJECTILE && (el as ProjectileGameObject).destroy).toList();
    for ( ProjectileGameObject proj in destroyList) {
      removeGameObject(proj);
    }
  }
  
  void addLaserShot(AbstractGameObject source, Vector position, Vector direction, double rotation) {
    
    
    Bitmap bitmap = new Bitmap(laserBitmapData);
    bitmap.scaleX = 2.0;
    bitmap.scaleY = 5.0;

    ProjectileGameObject projectile = new ProjectileGameObject(this, new FullRenderComponent(laserBitmapData, bitmap), source, direction);
    projectile.createCollisionData(new Vector(0.0, 0.0), new Vector(1.0, 1.0), box2d.BodyType.DYNAMIC, rotation);
    projectile.collisionComponent.body.setBullet(true);
    
    //projectile.addChild(bitmap);
    
    projectile.pivotX = bitmap.width / 2;
    projectile.pivotY = bitmap.width / 2;
    
    projectile.position = position;
    projectile.rotation = rotation;
    
    addGameObject(projectile);
  }

  static void drawTest(Graphics ctx, List<Vector> polygon, Vector Mouse) {
    ctx.clear();

    // DRAW AS A GIANT POLYGON
    //ctx.fillStyle = "#dd3838";
    ctx.beginPath();
    ctx.moveTo(polygon[0].x, polygon[0].y);
    for (var i = 1; i < polygon.length; i++) {
      var intersect = polygon[i];
      ctx.lineTo(intersect.x, intersect.y);
    }
    ctx.fillColor(0x00FFFFFF);
    //ctx.fillColor(Color.Green);
    //ctx.fillGradient()

    //var grad = new GraphicsGradient.linear(startX, startY, endX, endY);
    //grad.

    // DRAW DEBUG LINES
    //ctx.strokeStyle = "#f55";
    for (var i = 0; i < polygon.length; i++) {
      var intersect = polygon[i];
      ctx.beginPath();
      ctx.moveTo(Mouse.x, Mouse.y);
      ctx.lineTo(intersect.x, intersect.y);
      ctx.strokeColor(Color.Red);
    }
  }

  void setupPlayerObject(Vector startingPosition) {
    BitmapData bitmapData = loadBitmap("person"); // star1
    Bitmap bitmap = new Bitmap(bitmapData);
    bitmap.pivotX = bitmap.width / 2;
    bitmap.pivotY = bitmap.height / 2;

    bitmap.rotation = Math.PI;
    bitmap.scaleX = 0.3;
    bitmap.scaleY = 0.3;

    ControllableGameObject gameObj = new ControllableGameObject(
        this, new FullRenderComponent(bitmapData, bitmap), camera,
        _gameLoop.keyboardDevice,
        _gameLoop.mouseDevice,
        _gameLoop.gamepadDevice);
    //gameObj.addChild(bitmap);

    //gameObj.pivotX = gameObj.width / 2;
    //gameObj.pivotY = gameObj.height / 2;
    
    //-
    gameObj.createCollisionData(-new Vector(gameObj.bounds.width/2.0, gameObj.bounds.height/2.0), new Vector(1.0, 1.0), box2d.BodyType.DYNAMIC);

    gameObj.position = startingPosition;

    gameObj.collisionEnabled = true;

    addGameObject(gameObj);

    this.playerObject = gameObj;
  }

  void addBox(Vector position, Vector scale) {
    BitmapData bitmapData = loadBitmap("box");
    Bitmap bitmap = new Bitmap(bitmapData);

    StaticGameObject gameObj = new StaticGameObject(this,
      new FullRenderComponent(bitmapData, bitmap));
    //gameObj.addChild(bitmap);

    gameObj.scaleX = scale.x;
    gameObj.scaleY = scale.y;

    gameObj.position = position;
    gameObj.visibleSolid = true;
    gameObj.collisionEnabled = true;

    
    gameObj.createCollisionData(new Vector(0, 0),
      new Vector(scale.x, scale.y), box2d.BodyType.STATIC);
    addGameObject(gameObj);
  }

  void addShipVisibility() {
    BitmapData bitmapData = loadBitmap("spaceship1");

    

    //shape.graphics.rect(0, 0, 1280, 720);

    //shape.graphics.fillPattern(new GraphicsPattern.noRepeat(bitmapData.renderTextureQuad));
    //stage.addChild(shape);

    StaticGameObject gameObj = new StaticGameObject(this, new PartialRenderComponent(this, camera, bitmapData, playerObject));

    //VisibilityGameObject gameObj =
      //  new VisibilityGameObject(this, camera, shape, bitmapData, playerObject);
    //gameObj.addChild(shape);

    gameObj.scaleX = 3.0;
    gameObj.scaleY = 3.0;

    //gameObj.position = new Vector(300, 0);
    //shape.x = 300;
    //shape.y = 0;

    gameObj.visibleSolid = false;
    
    gameObj.collisionEnabled = true;

    addGameObject(gameObj);
  }

  BitmapData loadBitmap(String key) {
    return resourceManager.getBitmapData(key);
  }
  
  void addGameObject(AbstractGameObject gameObject) {
    gameObjects.add(gameObject);
    camera.addChild(gameObject);
    _gameLoop.addJuggler(gameObject);
  }
  
  void removeGameObject(AbstractGameObject gameObject) {
    gameObject.destroyObject();
    gameObjects.remove(gameObject);
    camera.removeChild(gameObject);
    _gameLoop.removeJuggler(gameObject);
  }

  List<Segment> getAllSegments() {
    List<Segment> segments = new List<Segment>();

    var cameraBounds = camera.cameraBounds;
    double left = cameraBounds.left;
    double right = cameraBounds.right;
    double top = cameraBounds.top;
    double bottom = cameraBounds.bottom;

    Vector topLeft = new Vector(left, top);
    Vector topRight = new Vector(right, top);
    Vector bottomLeft = new Vector(left, bottom);
    Vector bottomRight = new Vector(right, bottom);

    Segment s1 = new Segment(topLeft, topRight);
    Segment s2 = new Segment(topRight, bottomRight);
    Segment s3 = new Segment(bottomLeft, bottomRight);
    Segment s4 = new Segment(topLeft, bottomLeft);

    segments.addAll([s1, s2, s3, s4]);

    for (AbstractGameObject gameObject in gameObjects) {
      if (gameObject.visibleSolid) {
        segments.addAll(gameObject.getSegments().where((p) => cameraBounds.contains(p.a.x, p.a.y) || cameraBounds.contains(p.b.x, p.b.y)));
      }
    }
    return segments;
  }
}
