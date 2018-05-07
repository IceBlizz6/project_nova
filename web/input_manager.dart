import 'dart:collection';

class InputManager<T> {
  HashSet<T> _previous;
  HashSet<T> _current;
  HashSet<T> _active;

  InputManager() {
    _previous = new HashSet<T>();
    _current = new HashSet<T>();
    _active = new HashSet<T>();
  }

  void clearInputCache() {
    _previous.clear();
    _current.clear();
    _active.clear();
  }

  void buttonChangeState(T button, bool state) {
    if (state) {
      buttonDown(button);
    } else {
      buttonUp(button);
    }
  }

  void buttonDown(T button) {
    if (!_active.contains(button)) {
      _active.add(button);
    }
  }

  void buttonUp(T button) {
    if (_active.contains(button)) {
      _active.remove(button);
    }
  }

  bool isDown(T button) {
    return _current.contains(button);
  }

  bool isPressed(int keyCode) {
    return _current.contains(keyCode) && !_previous.contains(keyCode);
  }

  void update(double time) {
    _copyState(_current, _previous);
    _copyState(_active, _current);
  }

  static void _copyState<T>(HashSet<T> source, HashSet<T> target) {
    target.clear();
    target.addAll(source);
  }
}
