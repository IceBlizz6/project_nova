import 'dart:math' as Math;
import 'package:stagexl/stagexl.dart';
import 'dart:async';
import 'dart:html' as html;
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'keyboard_device.dart';
import 'gamepad_device.dart';
import 'dart:math';
import 'game_camera.dart';
import 'dart:math' as Math;
import 'mouse_device.dart';
import 'game_loop.dart';
import 'game_physics_object.dart';
import 'game_socket.dart';
import 'dart:collection';


class IntersectionData {
	Vector v;
	double param;
	double angle;
	
	IntersectionData(this.v, this.param) {
	
	}
}

class Segment {
	Vector a; // start
	Vector b; // stop
	
	Segment(this.a, this.b) {
	
	}
	
	List<Vector> getList() {
		return [ a, b ];
	}
}

class Ray {
	Vector start;
	Vector direction;
	
	Ray(this.start, this.direction) {
	
	}
	
	IntersectionData intersection(Segment segment) {
		CollisionRay r = new CollisionRay();
		r.a = start;
		r.b = start + direction;
		return r.intersection(segment);
	}
}

class CollisionRay {
	Vector a; // point of start
	Vector b; // start + normalized direction vector
	
	IntersectionData intersection(Segment segment) {
		return getIntersection(this, segment);
	}
	
	static List<IntersectionData> getSightPolygon(List<Segment> segments, Vector sight) {
		List<Vector> points = new List<Vector>();
		for (Segment segment in segments) {
			points.add(segment.a);
			points.add(segment.b);
		}
		
		List<Vector> uniquePoints = getUniquePoints(points);
		List<double> uniqueAngles = getAllAngles(uniquePoints, sight);
		List<IntersectionData> intersects = raysAllDirections(
			uniqueAngles, sight, segments);
		
	
		
		// Sort intersects by angle
		intersects.sort((a, b) => (a.angle > b.angle) ? 1 : -1);
		return intersects;
	}
	
	// Find intersection of RAY & SEGMENT
	static IntersectionData getIntersection(CollisionRay ray, Segment segment) {
		// RAY in parametric: Point + Delta*T1
		var r_px = ray.a.x;
		var r_py = ray.a.y;
		var r_dx = ray.b.x - ray.a.x;
		var r_dy = ray.b.y - ray.a.y;
		
		// SEGMENT in parametric: Point + Delta*T2
		var s_px = segment.a.x;
		var s_py = segment.a.y;
		var s_dx = segment.b.x - segment.a.x;
		var s_dy = segment.b.y - segment.a.y;
		
		// Are they parallel? If so, no intersect
		var r_mag = Math.sqrt(r_dx * r_dx + r_dy * r_dy);
		var s_mag = Math.sqrt(s_dx * s_dx + s_dy * s_dy);
		if (r_dx / r_mag == s_dx / s_mag && r_dy / r_mag == s_dy / s_mag) {
			// Unit vectors are the same.
			return null;
		}
		
		// SOLVE FOR T1 & T2
		// r_px+r_dx*T1 = s_px+s_dx*T2 && r_py+r_dy*T1 = s_py+s_dy*T2
		// ==> T1 = (s_px+s_dx*T2-r_px)/r_dx = (s_py+s_dy*T2-r_py)/r_dy
		// ==> s_px*r_dy + s_dx*T2*r_dy - r_px*r_dy = s_py*r_dx + s_dy*T2*r_dx - r_py*r_dx
		// ==> T2 = (r_dx*(s_py-r_py) + r_dy*(r_px-s_px))/(s_dx*r_dy - s_dy*r_dx)
		var T2 = (r_dx * (s_py - r_py) + r_dy * (r_px - s_px)) /
			(s_dx * r_dy - s_dy * r_dx);
		var T1 = (s_px + s_dx * T2 - r_px) / r_dx;
		
		// Must be within parametic whatevers for RAY/SEGMENT
		if (T1 < 0) return null;
		if (T2 < 0 || T2 > 1) return null;
		
		// Return the POINT OF INTERSECTION
		return new IntersectionData(
			new Vector(r_px + r_dx * T1, r_py + r_dy * T1), T1);
	}
	
	static List<Vector> getUniquePoints(List<Vector> points) {
		LinkedHashSet<Vector> unique = new LinkedHashSet<Vector>();
		unique.addAll(points);
		return unique.toList();
	}
	
	static List<double> getAllAngles(List<Vector> uniquePoints, Vector sight) {
		List<double> uniqueAngles = new List<double>();
		for (var j = 0; j < uniquePoints.length; j++) {
			var uniquePoint = uniquePoints[j];
			var angle = Math.atan2(uniquePoint.y - sight.y, uniquePoint.x - sight.x);
			//uniquePoint.angle = angle;
			uniqueAngles.add(angle - 0.00001);
			uniqueAngles.add(angle + 0.00001);
		}
		return uniqueAngles;
	}
	
	static List<IntersectionData> raysAllDirections(List<double> uniqueAngles,
		Vector sight, List<Segment> segments) {
		List<IntersectionData> intersects = new List<IntersectionData>();
		for (var j = 0; j < uniqueAngles.length; j++) {
			var angle = uniqueAngles[j];
			
			// Calculate dx & dy from angle
			var dx = Math.cos(angle);
			var dy = Math.sin(angle);
			
			// Ray from center of screen to mouse
			CollisionRay ray = new CollisionRay();
			ray.a = new Vector(sight.x, sight.y);
			ray.b = new Vector(sight.x + dx, sight.y + dy);
			
			// Find CLOSEST intersection
			IntersectionData closestIntersect = null;
			for (var i = 0; i < segments.length; i++) {
				IntersectionData intersect = getIntersection(ray, segments[i]);
				if (intersect == null) continue;
				if (closestIntersect == null || intersect.param < closestIntersect.param) {
					closestIntersect = intersect;
				}
			}
			
			// Intersect angle
			if (closestIntersect != null) {
				closestIntersect.angle = angle;
				
				// Add to list of intersects
				intersects.add(closestIntersect);
			}
			
		}
		
		return intersects;
	}
}

