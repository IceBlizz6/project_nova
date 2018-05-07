import 'package:stagexl/stagexl.dart';
import 'dart:collection';
import 'dart:html';
import 'input_manager.dart';

class GameCamera extends DisplayObjectContainer implements Animatable {
  //PhysicsObject physics;
  Stage _stage;
  num cameraSpeed = 400.0;
  Sprite target;

  GameCamera(this._stage) {
    //this.physics = new PhysicsObject();
    //physics.friction = 0.95;
  }
  
  Vector getOffset() {
    return new Vector(_stage.sourceWidth / 2, _stage.sourceHeight / 2);
  }

  void moveTowards(num x, num y, num time)  {
    //num setX = _move(getPositionX(), x, time, cameraSpeed);
    //num setY = _move(getPositionY(), y, time, cameraSpeed);
    
    //Vector current = new Vector(physics.position.x, physics.position.y);
    Vector destination = new Vector(x, y);
    
    //Vector offset = destination - current;
    //Vector direction = offset.normalize();
    //Vector acceleration = new Vector(direction.x * cameraSpeed, direction.y * cameraSpeed);
    
    //physics.acceleration += acceleration;
    
    //physics.velocityX += acceleration.x;
    //physics.velocityY += acceleration.y;
    
    
    
    
    //setPosition(setX, setY);
  }
  
  static num _move(num pos, num destination, num time, num speed) {
    num diff = (destination - pos).abs();
    bool direction = true;
    if (pos > destination) {
      direction = false;
    }
    num travelDistance = time * speed;
    
    if (travelDistance >= diff) {
      return destination;
    } else {
      num progress = travelDistance / diff;
      if (direction) {
        return pos + progress * diff;
      } else {
        return pos - progress * diff;
      }
    }
  }

  void setPosition(num x, num y) {
    var offset = getOffset();
    this.x = -x;
    this.y = -y;
    
  }

  num getPositionX() {
    var offset = getOffset();
    return -x;
  }

  num getPositionY() {
    var offset = getOffset();
    return -y;
  }

  @override
  bool advanceTime(num time) {
    // TODO: implement advanceTime
    if (target != null) {
      moveTowards(target.x, target.y, time);
    }
    //physics.update(time);
    //this.x = -physics.position.x;
    //this.y = -physics.position.y;

    return true;
  }
}
