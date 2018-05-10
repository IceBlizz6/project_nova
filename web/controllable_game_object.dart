import 'abstract_game_object.dart';
import 'dart:html';
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

  double maxSpeed = 50.0;
  Vector velocity = new Vector(0, 0);

  ControllableGameObject(GameScene scene, RenderComponent renderComponent, this.camera, this.keyboardDevice, this.mouseDevice,
      this.gamepadDevice)
      : super(scene, renderComponent) {}
      

  @override
  bool advanceTime(num time) {
    Vector acceleration;
    acceleration = new Vector(0, 0);
    double accelerationPower = 20.0;

    //double val =
    //double stickX = gamepadDevice.stickValue(0, 0);
    //double stickY = gamepadDevice.stickValue(0, 1);
    //acceleration += new Vector(stickX, stickY);
    //querySelector('#text').text = gamepadDevice.stickValue(0, 0).toString() + ", " + gamepadDevice.stickValue(0, 1).toString();

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

    acceleration = acceleration.scale(accelerationPower);

    num velX = velocity.x;
    num velY = velocity.y;

    if (acceleration.x == 0) {
      velX += -velX * 0.1;
    }
    if (acceleration.y == 0) {
      velY += -velY * 0.1;
    }

    velocity = new Vector(velX, velY);
    

    num mouseX = stage.mouseX;
    num mouseY = stage.mouseY;
    var m = camera.globalTransformationMatrix;
    m.invert();
    Vector transformedMousePos = m.transformVector(new Vector(mouseX, mouseY));
    
    //new Vector(mouseX - x, mouseY - y)
    Vector dir = (transformedMousePos - position).normalize();
    num rotValue = ((dir.degrees - 90) / 180) * Math.PI;
    rotation = rotValue;

    if (mouseDevice.isPressed(0)) {
      num dirX = Math.cos(rotation + Math.PI/2);
      num dirY = Math.sin(rotation + Math.PI/2);
      
      Vector shotDirection = new Vector(dirX, dirY);
      scene.addLaserShot(this, position, shotDirection, rotation);
      //createLaser(playerObject.position + shotDirection.scale(playerObject.height/4), shotDirection);
  
    }

    velocity += acceleration.scale(time);

    if (velocity.length > maxSpeed) {
      velocity = velocity.normalize().scale(maxSpeed);
    }
    
    Vector force = velocity.scale(100.0);
    
    collisionComponent.setVelocity(force.x, force.y);

    super.advanceTime(time);
  }
  
  @override
  bool intersects(AbstractGameObject otherGameObject) {
    if (otherGameObject is ProjectileGameObject) {
      return false;
    } else {
      return super.intersects(otherGameObject);
    }
  }
}
