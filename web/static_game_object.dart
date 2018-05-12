import 'abstract_game_object.dart';
import 'abstract_game_object.dart';
import 'dart:html';
import 'game_object_type.dart';
import 'game_scene.dart';
import 'keyboard_device.dart';
import 'mouse_device.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:math' as Math;
import 'gamepad_device.dart';
import 'game_camera.dart';
import 'projectile_game_object.dart';
import 'game_object_components/render_component.dart';

class StaticGameObject extends AbstractGameObject {
	
	StaticGameObject(GameScene scene, RenderComponent renderComponent)
		: super(scene, renderComponent) {}
		
		
		
  // TODO: implement gameObjectType
  @override
  GameObjectType get gameObjectType => GameObjectType.STATIC;
}