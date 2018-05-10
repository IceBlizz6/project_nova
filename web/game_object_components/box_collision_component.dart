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
		
		def.type = type;//BodyType.DYNAMIC;
		
		this.shape = new PolygonShape();
		//shape.setAsBox(sizeX, sizeY, new Vector2(0.0, 0.0), 0.0);
		//AABB box = new AABB.withVec2(new Vector2(0.0, 0.0), new Vector2(sizeX, sizeY));
		//Transform tr = new Transform.from(new Vector2(pivotX, pivotY), new Rot.withAngle(0.0));
		//shape.computeAABB(box, tr, 0);
		//shape.setAsBoxXY(sizeX, sizeY);
		//shape.
		
		Vector2 leftTop = new Vector2(0.0, 0.0);
		Vector2 leftBot = new Vector2(0.0, sizeY);
		Vector2 rightTop = new Vector2(sizeX, 0.0);
		Vector2 rightBot = new Vector2(sizeX, sizeY);
		
		var rawList = [ leftTop, leftBot, rightTop, rightBot ];
		
		//.map((e) => e - new Vector2(pivotX, pivotY)).toList()
		shape.set(rawList, 4);
		
		body = world.createBody(def);
		body.createFixtureFromShape(shape, 0.5);

		MassData d = new MassData();
		d.mass = 0.5;
		body.setMassData(d);
		
		this.points = shape.vertices;
		
		
		//world.destroyBody(body)
		
		
		//body.applyLinearImpulse(impulse, point, wake)
		//body.getFixtureList().setFriction(0.1);

		
	}
	
	
	
	Vector2 getPosition() {
		return body.position;
		//return def.getPosition();
		
	}
	
	void setPosition(double posX, double posY) {
		//body.position = new Vector2(posX, posY);
		body.setTransform(new Vector2(posX, posY) + pivot, 0.0);
		//def.setPosition(new Vector2(posX, posY));
	}
	
	void setVelocity(double velX, double velY) {
		body.applyForceToCenter(new Vector2(0.0, 0.0));
		
		body.linearVelocity.setValues(velX, velY);
		
		//body.linearVelocity
		
		//def.setLinearVelocity(new Vector2(velX, velY) * 100.0);
	}
	
	void updateFriction() {
		Vector2 velocity = body.linearVelocity;
		
	
	}


}