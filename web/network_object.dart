import 'dart:async';
import 'dart:html' as html;
import 'game_object_type.dart';
import 'package:stagexl/stagexl.dart';
import 'abstract_game_object.dart';
import 'game_scene.dart';
import 'game_object_components/render_component.dart';

class NetworkObject extends AbstractGameObject {
  double reportX;
  double reportY;
  double reportRotation;

  NetworkObject(GameScene scene, RenderComponent renderComponent)
    : super(scene, renderComponent) {}

  @override
  bool advanceTime(num time) {
    x = reportX;
    y = reportY;
    rotation = reportRotation;
    
    return super.advanceTime(time);
  }
  
  @override
  GameObjectType get gameObjectType => GameObjectType.PLAYER;
}
