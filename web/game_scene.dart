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
import 'game_physics_object.dart';
import 'controllable_game_object.dart';
import 'main.dart';
import 'game_map.dart';
import 'visibility_game_object.dart';
import 'collision_ray.dart';

class GameScene extends DisplayObjectContainer implements Animatable {
  GameLoop _gameLoop;
  ResourceManager resourceManager;
  List<AbstractGameObject> gameObjects;
  ControllableGameObject playerObject;
  // Map<String, NetworkObject> networkSprites = new Map<String, NetworkObject>();
  GameCamera camera;

  Shape wireShape;

  GameMap gameMap;

  GameScene(this._gameLoop, this.resourceManager) {
    gameObjects = new List<AbstractGameObject>();
    
    this.camera = new GameCamera(_gameLoop.keyboardDevice);
    this.addChild(camera);
    _gameLoop.addJuggler(camera);
    camera.x = 0.0;
    camera.y = 0.0;
    
    this.gameMap = new GameMap(this);
    setupPlayerObject(new Vector(200, 200));
    addBox(new Vector(400, 300), new Vector(0.5, 2.0));
    addShipVisibility();
    
    
    camera.target = playerObject;

    this.wireShape = new Shape();
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
        this, camera,
        _gameLoop.keyboardDevice,
        _gameLoop.mouseDevice,
        _gameLoop.gamepadDevice);
    gameObj.addChild(bitmap);

    //gameObj.pivotX = gameObj.width / 2;
    //gameObj.pivotY = gameObj.height / 2;

    gameObj.position = startingPosition;

    gameObj.collisionEnabled = true;

    addGameObject(gameObj);

    this.playerObject = gameObj;
  }

  void addBox(Vector position, Vector scale) {
    BitmapData bitmapData = loadBitmap("box");
    Bitmap bitmap = new Bitmap(bitmapData);

    GamePhysicsObject gameObj = new GamePhysicsObject(this);
    gameObj.addChild(bitmap);

    gameObj.scaleX = scale.x;
    gameObj.scaleY = scale.y;

    gameObj.position = position;
    gameObj.visibleSolid = true;
    gameObj.collisionEnabled = true;

    addGameObject(gameObj);
  }

  void addShipVisibility() {
    BitmapData bitmapData = loadBitmap("spaceship1");

    Shape shape = new Shape();

    //shape.graphics.rect(0, 0, 1280, 720);

    //shape.graphics.fillPattern(new GraphicsPattern.noRepeat(bitmapData.renderTextureQuad));
    //stage.addChild(shape);

    VisibilityGameObject gameObj =
        new VisibilityGameObject(this, camera, shape, bitmapData, playerObject);
    gameObj.addChild(shape);

    gameObj.scaleX = 1.0;
    gameObj.scaleY = 1.0;

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
    //_gameLoop.add(gameObject);
    camera.addChild(gameObject);

    if (gameObject is Animatable) {
      _gameLoop.addJuggler(gameObject);
    }
  }

  void addMap(Sprite backgroundSprite) {
    camera.addChild(backgroundSprite);
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

  Vector collisionCheck2(
      AbstractGameObject gameObj, Vector startPosition, Vector targetPosition) {
    const int stepSize = 3;
    double distance = (targetPosition - startPosition).length;
    int lerpSteps = (distance / stepSize).ceil();

    Vector lastPos = startPosition;
    for (int i = 1; i <= lerpSteps; i++) {
      Vector testPosition =
          startPosition.lerp(targetPosition, i.toDouble() / lerpSteps);

      int posX = (testPosition.x / stepSize).toInt() * stepSize;
      int posY = (testPosition.y / stepSize).toInt() * stepSize;

      Vector snatchPosition;
      if (i >= lerpSteps - 1) {
        snatchPosition = testPosition;
      } else {
        snatchPosition = new Vector(posX, posY);
      }

      gameObj.position = new Vector(0, 0);
      gameObj.position = snatchPosition;
      bool collide = collisionDetectionStatic(gameObj);

      if (collide) {
        gameObj.position = startPosition;
        return lastPos;
      } else {
        lastPos = snatchPosition;
      }
    }
    gameObj.position = startPosition;
    return lastPos;
  }

  double nextStepValue(double current, double target, int stepDistance) {
    double travelDistance = (target - current).abs();

    if (travelDistance >= stepDistance) {
      return target;
    } else {
      int curr = closestInt(current, target);
      //int v = current.ce
    }
  }

  int nexPosInt(double current, double target, int stepDistance) {
    int neighbour = closestInt(current, target);
  }

  int closestInt(double current, double target) {
    if (target > current) {
      return current.ceil();
    } else {
      return current.floor();
    }
  }

  Vector checkCollisionMovement(
      AbstractGameObject gameObj, Vector startPosition, Vector targetPosition) {
    num stepSize = Math.min(gameObj.bounds.width, gameObj.bounds.height) / 2;
    Vector travel = (targetPosition - startPosition);
    num length = travel.length;
    int steps = (length / stepSize).ceil();

    Vector lastPosition = startPosition;
    for (int i = 1; i <= steps; i++) {
      Vector current = startPosition.lerp(targetPosition, i.toDouble() / steps);
      gameObj.position = current;
      //gameObj.position += checkBounds(gameObj);
      bool collide = collisionDetectionStatic(gameObj);
      if (collide) {
        return lastPosition;
      } else {
        //lastPosition = gameObj.position;
      }
    }
    return targetPosition;
  }
  
  Vector checkBounds(AbstractGameObject gameObject) {
    return checkMapBounds(gameObject.boundsTransformed,
      gameMap.mapStart, gameMap.mapEnd);
  
  }
  
  static Vector checkMapBounds(var boundsTransformed, Vector mapStart, Vector mapEnd) {
    //x = Math.max(0, x);
    
    double offsetX = 0.0;
    double offsetY = 0.0;
  
    if (boundsTransformed.left < mapStart.x) {
      double displace = mapStart.x - boundsTransformed.left;
      offsetX += displace;
    }
  
    if (boundsTransformed.right > mapEnd.x) {
      double displace = boundsTransformed.right - mapEnd.x;
      offsetX -= displace;
    }
  
    if (boundsTransformed.top < mapStart.y) {
      double displace = mapStart.y - boundsTransformed.top;
      offsetY += displace;
    }
  
    if (boundsTransformed.bottom > mapEnd.y) {
      double displace = boundsTransformed.bottom - mapEnd.y;
      offsetY -= displace;
    }
    
    return new Vector(offsetX, offsetY);
  }

  bool collisionDetectionStatic(AbstractGameObject gameObj) {
    for (AbstractGameObject obj in gameObjects) {
      if (obj != gameObj && obj.intersects(gameObj)) {
        return true;
      }
    }
    return false;
  }
}
