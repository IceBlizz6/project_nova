import 'package:box2d/box2d.dart';
import '../abstract_game_object.dart';
import '../projectile_game_object.dart';
import '../game_object_type.dart';

class CustomContactListener extends ContactListener {

  @override
  void beginContact(Contact contact) {
    // TODO: implement beginContact
		//print("CONTACT!");
		//contact.
    
    
    collisionLogic(contact.fixtureA.userData as AbstractGameObject,
      contact.fixtureB.userData as AbstractGameObject);
		
  }

  @override
  void endContact(Contact contact) {
    // TODO: implement endContact
  }

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {
    // TODO: implement postSolve
  }

  @override
  void preSolve(Contact contact, Manifold oldManifold) {
    // TODO: implement preSolve
  }
  
  void collisionLogic(AbstractGameObject gameObj1, AbstractGameObject gameObj2) {
    var list = [ gameObj1, gameObj2 ];
    list.sort((el1, el2) => el1.gameObjectType.index.compareTo(el2.gameObjectType.index));
    
    if (list[0].gameObjectType == GameObjectType.PROJECTILE) {
      ProjectileGameObject proj = list[0] as ProjectileGameObject;
      proj.destroy = true;
    }
  }
  
  bool containsProjectile(Fixture fix1, Fixture fix2) {
    var list = [ fix1.userData as AbstractGameObject, fix2.userData as AbstractGameObject ];
    return list.any((el) => el.gameObjectType == GameObjectType.PROJECTILE);
  }
}