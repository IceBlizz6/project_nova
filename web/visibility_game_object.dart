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
import 'collision_ray.dart';
import 'package:stagexl/stagexl.dart' as StageXL;

class VisibilityGameObject extends AbstractGameObject {
	GameCamera camera;
  Shape shape;
  BitmapData bitmapData;
  AbstractGameObject observingGameObject;

  VisibilityGameObject(
      GameScene scene, this.camera, this.shape, this.bitmapData, this.observingGameObject)
      : super(scene) {}

  @override
  bool advanceTime(num time) {
    
    
    List<Segment> segments = scene.getAllSegments();
    List<IntersectionData> polygons =
        CollisionRay.getSightPolygon(segments, observingGameObject.position);
    
    var matrix = this.globalTransformationMatrix;
    matrix.invert();
    
    var matrix2 = camera.globalTransformationMatrix;
    //matrix2.invert();

    shape.applyCache(0, 0, bitmapData.width, bitmapData.height);
    
    List<Vector> pList = polygons.map((el) => matrix.transformVector(el.v)).toList();
		List<Vector> pList2 = pList.map((el) => matrix2.transformVector(el)).toList();
    drawTest(shape.graphics, pList2);

    print(this.bounds.width);
    //this.bou
    
    return super.advanceTime(time);
  }
  
  @override
  get bounds {
    return new StageXL.Rectangle<num>(0.0, 0.0,
      bitmapData.width, bitmapData.height);
  }

  void drawTest(Graphics ctx, List<Vector> polygon) {
    ctx.clear();

    ctx.beginPath();
    ctx.moveTo(polygon[0].x, polygon[0].y);
    for (var i = 1; i < polygon.length; i++) {
      Vector intersect = polygon[i];
      ctx.lineTo(intersect.x, intersect.y);
    }
    ctx.closePath();

    shape.graphics.fillPattern(
        new GraphicsPattern.noRepeat(bitmapData.renderTextureQuad));
  }
}
