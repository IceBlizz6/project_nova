import 'package:stagexl/src/geom/matrix.dart';
import 'render_component.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:math' as Math;
import 'dart:async';
import 'dart:html' as html;
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'dart:math';
import 'dart:math' as Math;
import 'package:stagexl/stagexl.dart' as StageXL;

class FullRenderComponent extends Sprite implements RenderComponent {
	BitmapData bitmapData;
	Bitmap bitmap;

	FullRenderComponent(this.bitmapData, this.bitmap) {
		this.addChild(bitmap);
	}

  @override
  void renderUpdate(StageXL.Matrix globalTransformationMatrix) {
    // TODO: implement renderUpdate
  }

	@override
	dynamic get componentBounds {
		return this.bounds;
		//return new StageXL.Rectangle<num>(0.0, 0.0,
		//	bitmap.width, bitmap.height);
	}
  
}