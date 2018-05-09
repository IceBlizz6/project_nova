import 'abstract_game_object.dart';
import 'game_scene.dart';
import 'package:stagexl/stagexl.dart';

class ProjectileGameObject extends AbstractGameObject {
	Vector direction;
	
	ProjectileGameObject(GameScene scene, this.direction) : super(scene) {
	
	}
	
	@override
	bool advanceTime(num time) {
		this.position += direction.scale(40.0);
		
		return super.advanceTime(time);
	}
}