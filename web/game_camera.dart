import 'package:stagexl/stagexl.dart';
import 'dart:collection';
import 'dart:html';
import 'input_manager.dart';
import 'keyboard_device.dart';
import 'controllable_game_object.dart';
import 'package:stagexl/stagexl.dart' as StageXL;

class GameCamera extends DisplayObjectContainer implements Animatable {
  num cameraSpeed = 400.0;
  ControllableGameObject target;
  KeyboardDevice keyboardDevice;
  
  Vector cameraPos = new Vector(0, 0);
  Vector cameraSize = new Vector(1280, 720);

  GameCamera(this.keyboardDevice) {
  }

  Vector getOffset() {
    return new Vector(cameraSize.x / 2, cameraSize.y / 2);
  }
  
  void findTargetPosition(Vector target) {
    Vector currentCenter = cameraPos + getOffset();
    Vector offset = target - currentCenter;
    cameraPos += offset;
  
  }
  
  StageXL.Rectangle<num> get cameraBounds {
  	return new StageXL.Rectangle<num>(cameraPos.x, cameraPos.y, cameraSize.x, cameraSize.y);
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
    Vector move = new Vector(0, 0);
    
    if (keyboardDevice.isDown(KeyCode.UP)) {
      move += new Vector(0, -1);
    }

    if (keyboardDevice.isDown(KeyCode.DOWN)) {
      move += new Vector(0, 1);
    }

    if (keyboardDevice.isDown(KeyCode.LEFT)) {
      move += new Vector(-1, 0);
    }

    if (keyboardDevice.isDown(KeyCode.RIGHT)) {
      move += new Vector(1, 0);
    }
    
    if (move.x != 0.0 || move.y != 0.0) {
      cameraPos += move.scale(10.0);
    } else if (target != null) {
      Vector v = target.position;
      findTargetPosition(v);
    }
    
    


    
    this.x = -cameraPos.x;
    this.y = -cameraPos.y;
    return true;
  }
}
