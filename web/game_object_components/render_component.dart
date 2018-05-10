import 'package:stagexl/stagexl.dart' as StageXL;
import 'package:stagexl/stagexl.dart';

abstract class RenderComponent implements DisplayObject {
	
	dynamic get componentBounds;
	
	void renderUpdate(StageXL.Matrix globalTransformationMatrix);
	
}