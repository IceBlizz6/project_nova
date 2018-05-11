import 'package:box2d/box2d.dart';

class CustomContactListener extends ContactListener {

  @override
  void beginContact(Contact contact) {
    // TODO: implement beginContact
		//print("CONTACT!");
		//contact.
		
		//contact.fixtureA.
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
}