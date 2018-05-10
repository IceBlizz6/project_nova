import 'package:box2d/box2d.dart';

class BoxCollisionComponent {
	static final double globalMultiplier = 0.01;
	
	Body body;
	PolygonShape shape;
	List<Vector2> points;
	Vector2 pivot;
	
	BoxCollisionComponent(World world, double pivotX, double pivotY,
		double sizeX, double sizeY, BodyType type, [ double rotation = 0.0 ]) {
		
		this.pivot = new Vector2(pivotX, pivotY) * globalMultiplier;
		BodyDef def = new BodyDef();

		def.type = type;
		
		this.shape = new PolygonShape();

		Vector2 leftTop = new Vector2(0.0, 0.0);
		Vector2 leftBot = new Vector2(0.0, sizeY * globalMultiplier);
		Vector2 rightTop = new Vector2(sizeX * globalMultiplier, 0.0);
		Vector2 rightBot = new Vector2(sizeX * globalMultiplier, sizeY * globalMultiplier);
		
		var rawList = [ leftTop, leftBot, rightTop, rightBot ];
		
		var mat = new Matrix2.rotation(rotation);
		
		shape.set(rawList.map((e) => mat.transform(e)).toList(), 4);
		
		body = world.createBody(def);
		
	
		
		body.createFixtureFromShape(shape);
		
		this.points = shape.vertices;
	}
	
	Vector2 getPosition() {
		return body.position * 1.0/globalMultiplier - pivot * 1.0/globalMultiplier ;
	}
	
	List<Vector2> getScaledPoints() {
		return points.map((e) => e * 1.0/globalMultiplier + pivot * 1.0/globalMultiplier).toList();
	}
	
	void setPosition(double posX, double posY) {
		body.setTransform(new Vector2(posX, posY) * globalMultiplier + pivot, 0.0);
	}
	
	void applyForce(double x, double y) {
		body.applyLinearImpulse(new Vector2(x, y), body.worldCenter, true);
		//body.applyForceToCenter(new Vector2(x, y));
	}
	
	void updateFriction() {
		Vector2 velocity = body.linearVelocity;
		body.applyForceToCenter(-velocity * 0.7);
	}


}