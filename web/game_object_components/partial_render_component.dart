import 'dart:async';
import 'dart:html' as html;
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import '../keyboard_device.dart';
import '../gamepad_device.dart';
import 'dart:math';
import '../game_camera.dart';
import 'dart:math' as Math;
import '../mouse_device.dart';
import '../abstract_game_object.dart';
import '../game_scene.dart';
import '../collision_ray.dart';
import 'package:stagexl/stagexl.dart' as StageXL;
import 'render_component.dart';

class PartialRenderComponent extends Shape implements RenderComponent {
	GameScene scene;
	GameCamera camera;
	BitmapData bitmapData;
	AbstractGameObject observingGameObject;
	
	PartialRenderComponent(this.scene, this.camera, this.bitmapData, this.observingGameObject) {
	}
	
	@override
	get componentBounds {
		return new StageXL.Rectangle<num>(0.0, 0.0,
			bitmapData.width, bitmapData.height);
	}
	
	void renderUpdate(StageXL.Matrix globalTransformationMatrix) {
		List<Segment> segments = scene.getAllSegments();
		List<IntersectionData> polygons =
		CollisionRay.getSightPolygon(segments, observingGameObject.position);
		
		var matrix = globalTransformationMatrix;
		matrix.invert();
		
		var matrix2 = camera.globalTransformationMatrix;
		
		this.applyCache(0, 0, bitmapData.width, bitmapData.height);
		
		List<Vector> pList = polygons.map((el) => matrix.transformVector(el.v)).toList();
		List<Vector> pList2 = pList.map((el) => matrix2.transformVector(el)).toList();
		_drawTest(this.graphics, pList2);
	}
	
	void _drawTest(Graphics ctx, List<Vector> polygon) {
		ctx.clear();
		
		ctx.beginPath();
		ctx.moveTo(polygon[0].x, polygon[0].y);
		for (var i = 1; i < polygon.length; i++) {
			Vector intersect = polygon[i];
			ctx.lineTo(intersect.x, intersect.y);
		}
		ctx.closePath();
		
		ctx.fillPattern(
			new GraphicsPattern.noRepeat(bitmapData.renderTextureQuad));
	}

}