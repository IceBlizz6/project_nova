import 'input_manager.dart';
import 'dart:html';

import 'package:stagexl/stagexl.dart' as StageXL;

class MouseDevice extends InputManager<int> implements StageXL.Animatable {
	num _x;
	num _y;
	
	MouseDevice() {
		window.onMouseMove.listen((event) => moveEvent(event));
		window.onMouseDown.listen((event) => downEvent(event));
		window.onMouseUp.listen((event) => upEvent(event));
	}
	
	void upEvent(MouseEvent event) {
		buttonUp(event.button);
	}
	
	void downEvent(MouseEvent event) {
		buttonDown(event.button);
	}
	
	void moveEvent(MouseEvent event) {
		_x = event.client.x;
		_y = event.client.y;
	}
	
	@override
	bool advanceTime(num time) {
		// TODO: implement advanceTime
		
		
		
		
		update(time);
		return true;
	}

}