import 'package:stagexl/stagexl.dart';
import 'dart:collection';
import 'dart:html';
import 'input_manager.dart';

class KeyboardDevice implements Animatable {
  InputManager<int> input;

  KeyboardDevice() {
    this.input = new InputManager<int>();

    window.onKeyDown.listen((e) {
      // If the key is not set yet, set it with a timestamp.
      input.buttonDown(e.keyCode);
    });
    window.onKeyUp.listen((e) {
      input.buttonUp(e.keyCode);
    });
  }

  bool isDown(int keyCode) {
    return input.isDown(keyCode);
  }

  bool isPressed(int keyCode) {
    return input.isPressed(keyCode);
  }

  void update(double time) {
    input.update(time);
  }

  @override
  bool advanceTime(num time) {
    // TODO: implement advanceTime

    update(time);
    return true;
  }
}
