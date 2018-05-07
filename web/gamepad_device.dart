import 'dart:async';
import 'dart:html' as html;
import 'dart:html';
import 'input_manager.dart';

import 'package:stagexl/stagexl.dart';

class GamepadDevice extends InputManager<GamepadButton> implements Animatable {
  int _index;

  GamepadDevice(this._index) {}

  List<GamepadButton> getButtons() {
    return getGamepad().buttons;
  }

  Gamepad getGamepad() {
    return window.navigator.getGamepads()[_index];
  }

  bool isConnected() {
    return getGamepad() != null;
  }

  double stickValue(int stickIndex, int axesIndex) {
    double originalValue =
        getGamepad().axes[stickIndex * 2 + axesIndex].toDouble();
    int roundedValue = (originalValue * 10.0)
        .round(); // stick value inaccurate at 1/100, using 1/10
    return roundedValue.toDouble() / 10.0;
  }

  bool anyButtonDown() {
    List<GamepadButton> buttons = getButtons();
    for (GamepadButton button in buttons) {
      if (isDown(button)) {
        return true;
      }
    }
    return false;
  }

  @override
  bool advanceTime(num time) {
    if (isConnected()) {
      List<GamepadButton> buttons = getButtons();
      for (GamepadButton button in buttons) {
        bool wasDown = isDown(button);
        bool currentlyDown = button.pressed;
        if (wasDown != currentlyDown) {
          buttonChangeState(button, currentlyDown);
        }
      }
    } else {
      clearInputCache();
    }

    update(time);
    return true;
  }
}
