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

class VisibilityGameObject extends AbstractGameObject {
	Shape shape;
	BitmapData bitmapData;
	AbstractGameObject observingGameObject;
	
	
	VisibilityGameObject(GameScene scene, this.shape, this.bitmapData, this.observingGameObject)
		: super(scene) {
	}
	
	@override
	bool advanceTime(num time) {
		//shape.graphics.clear();
		
		
		
		//CollisionRay collisionRay = new CollisionRay();
		
		
		//print(polygons.length);
		
		//shape.applyCache(450, 200, 100, 100);
		
		
		//drawTest(shape.graphics, pList, observingGameObject.position);
		
		List<Segment> segments = scene.getAllSegments();
		List<IntersectionData> polygons = CollisionRay.getSightPolygon(segments, observingGameObject.position);
		
		List<Vector> pList = polygons.map((el) => el.v).toList();
		
		drawTest(shape.graphics, pList);
		
		
		
		//fill2(shape.graphics, observingGameObject.position);
		
		return super.advanceTime(time);
	}
	
	void drawTest(Graphics ctx, List<Vector> polygon) {
		
		ctx.clear();
		
		ctx.beginPath();
		ctx.moveTo(polygon[0].x, polygon[0].y);
		for(var i=1;i<polygon.length;i++){
			Vector intersect = polygon[i];
			ctx.lineTo(intersect.x, intersect.y);
		}
		ctx.closePath();
		//shape.graphics.strokePattern(new GraphicsPattern.repeat(bitmapData.renderTextureQuad));
		
		//ctx.strokeColor(Color.Black);
		//ctx.fillColor(Color.Black);
		shape.graphics.fillPattern(new GraphicsPattern.noRepeat(bitmapData.renderTextureQuad));
	}
	
	
	
	void fill2(Graphics ctx, Vector Mouse) {
		var fuzzyRadius = 5;
		
		//ctx.fillStyle = "#fff";
		ctx.beginPath();
		ctx.arc(Mouse.x, Mouse.y, 2, 0, 2*Math.PI, false);
		//ctx.fill();
		ctx.fillColor(Color.Black);
		
		for(double angle=0.0;angle<Math.PI*2;angle+=(Math.PI*2.0)/10.0){
			var dx = Math.cos(angle)*fuzzyRadius;
			var dy = Math.sin(angle)*fuzzyRadius;
			ctx.beginPath();
			ctx.arc(Mouse.x+dx, Mouse.y+dy, 2, 0, 2*Math.PI, false);
			//ctx.fill();
			ctx.fillColor(Color.Black);
		}
	}
}