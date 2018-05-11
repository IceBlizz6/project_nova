import 'package:box2d/box2d.dart';
import '../abstract_game_object.dart';
import '../controllable_game_object.dart';
import '../projectile_game_object.dart';

class CustomContactFilter extends ContactFilter {
	@override
	bool shouldCollide(Fixture fixtureA, Fixture fixtureB) {
		AbstractGameObject gameObj1 = fixtureA.userData;
		AbstractGameObject gameObj2 = fixtureB.userData;
		
		if (gameObj1 is ControllableGameObject && gameObj2 is ProjectileGameObject) {
			return false;
		} else if (gameObj1 is ProjectileGameObject && gameObj2 is ControllableGameObject) {
			return false;
		} else {
			return super.shouldCollide(fixtureA, fixtureB);
		}
		
	}
}