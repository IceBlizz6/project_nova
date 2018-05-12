import 'abstract_game_object.dart';
import 'game_object_type.dart';
import 'game_scene.dart';
import 'package:stagexl/stagexl.dart';
import 'game_object_components/render_component.dart';
import 'game_object_type.dart';

class ProjectileGameObject extends AbstractGameObject {
	AbstractGameObject source;
	Vector direction;
	bool speedInit = false;
	
	
	
	ProjectileGameObject(GameScene scene, RenderComponent renderComponent, this.source, this.direction) : super(scene, renderComponent) {
		this.collisionEnabled = true;
	}
	
	@override
	bool advanceTime(num time) {

		if (!speedInit) {
			double power = 18.0;
			Vector force = direction.scale(power);
			collisionComponent.applyForce(force.x, force.y);
			speedInit = true;
		}

		return super.advanceTime(time);
	}
  // TODO: implement gameObjectType
  @override
  GameObjectType get gameObjectType => GameObjectType.PROJECTILE;
}