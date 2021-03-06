import 'abstract_game_object.dart';
import 'dart:html';
import 'game_object_type.dart';
import 'game_scene.dart';
import 'keyboard_device.dart';
import 'mouse_device.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:math' as Math;
import 'gamepad_device.dart';
import 'game_camera.dart';
import 'projectile_game_object.dart';
import 'game_object_components/render_component.dart';

class ControllableGameObject extends AbstractGameObject {
  GameCamera camera;
  KeyboardDevice keyboardDevice;
  MouseDevice mouseDevice;
  GamepadDevice gamepadDevice;
  bool inputMode;
  
  

  ControllableGameObject(GameScene scene, RenderComponent renderComponent, this.camera, this.keyboardDevice, this.mouseDevice,
      this.gamepadDevice)
      : super(scene, renderComponent) {}
      

  @override
  bool advanceTime(num time) {
  
		handleRotation();
		handleShooting();
		
		//print(collisionComponent.getScaledPoints());
		//print(collisionComponent.points[0].y - collisionComponent.points[1].y);
		
    Vector acceleration = new Vector(0, 0);

    if (keyboardDevice.isDown(KeyCode.W)) {
      acceleration += new Vector(0, -1);
    }

    if (keyboardDevice.isDown(KeyCode.S)) {
      acceleration += new Vector(0, 1);
    }

    if (keyboardDevice.isDown(KeyCode.A)) {
      acceleration += new Vector(-1, 0);
    }

    if (keyboardDevice.isDown(KeyCode.D)) {
      acceleration += new Vector(1, 0);
    }
    
    if (acceleration != new Vector.zero()) {
			acceleration = acceleration.normalize();
		}

    Vector force = acceleration.scale(0.04);
    
    //collisionComponent.setVelocity();
    collisionComponent.applyForce(force.x, force.y);
    
    collisionComponent.updateFriction();

    super.advanceTime(time);
  }
  
  void handleRotation() {
		num mouseX = stage.mouseX;
		num mouseY = stage.mouseY;
		var m = camera.globalTransformationMatrix;
		m.invert();
		Vector transformedMousePos = m.transformVector(new Vector(mouseX, mouseY));
	
		//new Vector(mouseX - x, mouseY - y)
		Vector dir = (transformedMousePos - position).normalize();
		num rotValue = ((dir.degrees - 90) / 180) * Math.PI;
		rotation = rotValue;
	}
	
	void handleShooting() {
		if (mouseDevice.isPressed(0)) {
			num dirX = Math.cos(rotation + Math.PI/2);
			num dirY = Math.sin(rotation + Math.PI/2);
			
			Vector shotDirection = new Vector(dirX, dirY);
			scene.addLaserShot(this, position, shotDirection, rotation);
			//createLaser(playerObject.position + shotDirection.scale(playerObject.height/4), shotDirection);
			
		}
	}
  
  @override
  bool intersects(AbstractGameObject otherGameObject) {
    if (otherGameObject is ProjectileGameObject) {
      return false;
    } else {
      return super.intersects(otherGameObject);
    }
  }
  // TODO: implement gameObjectType
  @override
  GameObjectType get gameObjectType => GameObjectType.PLAYER;
}
