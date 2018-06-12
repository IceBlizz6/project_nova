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
import 'package:stagexl/stagexl.dart' as StageXL;
import 'game_object_components/render_component.dart';
import 'game_object_components/box_collision_component.dart';
import 'package:box2d/box2d.dart' as box2d;
import 'game_object_type.dart';

abstract class AbstractGameObject extends Sprite implements Animatable {
  GameScene scene;
	bool collisionEnabled = false; // false to let players walk through
	
	bool visibleSolid = false; // true to hide objects behind this (can't see through it)

	RenderComponent renderComponent; // full or partial render of the object

	bool isNetworkControlled = false; // true to query position updates from network
	
	Shape collisionShape;

	BoxCollisionComponent collisionComponent;
	
	double boundsWidth;
	double boundsHeight;

	bool destroy = false;
	
	//Vector collisionOffset = new Vector.zero();

  AbstractGameObject(this.scene, this.renderComponent) {
  	if (renderComponent != null) {
			this.addChild(renderComponent);
		}
  
	}
	
	void createCollisionData(Vector offset, Vector scale, box2d.BodyType type, [ double rotation = 0.0 ]) {
  	
  	//this.collisionOffset = offset;
		
		this.collisionShape = new Shape();
		this.scene.camera.addChild(collisionShape);
		this.boundsWidth = bounds.width * scale.x;
		this.boundsHeight = bounds.height * scale.y;
		
  //
		this.collisionComponent = new BoxCollisionComponent(this, scene.world, offset.x, offset.y, boundsWidth, boundsHeight, type, rotation);
		collisionComponent.setPosition(this.x, this.y);
	}

	GameObjectType get gameObjectType;

  Vector get position => new Vector(x, y);

  void set position(Vector value) {
    x = value.x;
    y = value.y;
    if (collisionComponent != null) {
			this.collisionComponent.setPosition(x, y);
		}
		
  }
  
  void destroyObject() {
  	if (collisionComponent != null) {
			collisionComponent.destroy();
			this.scene.camera.removeChild(collisionShape);
		}
	}

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
	get bounds {
  	return renderComponent.componentBounds;
	}
  
  @override
  bool advanceTime(num time) {
  	renderComponent.renderUpdate(renderComponent.globalTransformationMatrix);
  	
  	if (collisionShape != null) {
			collisionShape.graphics.clear();
			
			double myX = collisionComponent.getPosition().x;
			double myY = collisionComponent.getPosition().y;
			
			var scaledPoints = collisionComponent.getScaledPoints();
			
			collisionShape.graphics.beginPath();
			collisionShape.graphics.moveTo(scaledPoints[0].x + myX, scaledPoints[0].y + myY);
			
			for (int i = 1;i<collisionComponent.points.length;i++) {
				collisionShape.graphics.lineTo(scaledPoints[i].x + myX,
					scaledPoints[i].y + myY);
			}
			collisionShape.graphics.closePath();
			
			//collisionShape.graphics.rect(this.x + collisionOffset.x, this.y + collisionOffset.y, boundsWidth, boundsHeight);
			//collisionShape.graphics.
			collisionShape.graphics.strokeColor(Color.Blue);
		}
  
	
		//collisionComponent.setPosition(this.x, this.y);
		if (collisionComponent != null) {
			var updatedPos = collisionComponent.getPosition() - collisionComponent.pivot;
			this.x = updatedPos.x;
			this.y = updatedPos.y;
		}
		
    return true;
  }
}

