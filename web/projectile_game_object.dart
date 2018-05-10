import 'abstract_game_object.dart';
import 'game_scene.dart';
import 'package:stagexl/stagexl.dart';
import 'game_object_components/render_component.dart';

class ProjectileGameObject extends AbstractGameObject {
	AbstractGameObject source;
	Vector direction;
	
	ProjectileGameObject(GameScene scene, RenderComponent renderComponent, this.source, this.direction) : super(scene, renderComponent) {
		this.collisionEnabled = true;
	}
	
	@override
	bool advanceTime(num time) {
		Vector movement = direction.scale(30.0);
		
		//AbstractGameObject collisionObject = scene.collisionObjectCheck(this, position, position + movement, [ source ]);
	
		
		
		return super.advanceTime(time);
	}
}