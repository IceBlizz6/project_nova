import 'package:box2d/box2d.dart';

class BoxCollisionComponent {
	Body body;
	PolygonShape shape;
	List<Vector2> points;
	Vector2 pivot;
	
	BoxCollisionComponent(World world, double pivotX, double pivotY,
		double sizeX, double sizeY, BodyType type) {
		
		this.pivot = new Vector2(pivotX, pivotY);
		BodyDef def = new BodyDef();
		
		def.type = type;
		
		this.shape = new PolygonShape();

		Vector2 leftTop = new Vector2(0.0, 0.0);
		Vector2 leftBot = new Vector2(0.0, sizeY);
		Vector2 rightTop = new Vector2(sizeX, 0.0);
		Vector2 rightBot = new Vector2(sizeX, sizeY);
		
		var rawList = [ leftTop, leftBot, rightTop, rightBot ];

		shape.set(rawList, 4);
		
		body = world.createBody(def);
		body.createFixtureFromShape(shape, 0.5);

		MassData d = new MassData();
		d.mass = 0.5;
		body.setMassData(d);
		
		this.points = shape.vertices;
	}
	
	Vector2 getPosition() {
		return body.position;
		
	}
	
	void setPosition(double posX, double posY) {
		body.setTransform(new Vector2(posX, posY) + pivot, 0.0);
	}
	
	void applyForce(double x, double y) {
		body.applyForceToCenter(new Vector2(x, y));
	}
	
	void updateFriction() {
		Vector2 velocity = body.linearVelocity;
		body.applyForceToCenter(-velocity * 0.7);
	}


}