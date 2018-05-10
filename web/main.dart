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
import 'game_socket.dart';
import 'dart:collection';

Future<Null> main() async {
  Stage stage = setupStageInit();
  ResourceManager resourceManager = await setupResources();

  GameLoop gameLoop = new GameLoop(resourceManager, stage);
  stage.juggler.add(gameLoop);
}

Stage setupStageInit() {
  StageOptions options = new StageOptions()
    ..backgroundColor = Color.Black
    ..stageScaleMode = StageScaleMode.NO_SCALE
    ..renderEngine = RenderEngine.WebGL;

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 1280, height: 720, options: options);

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  return stage;
}

Future<ResourceManager> setupResources() async {
  var resourceManager = new ResourceManager();

  resourceManager.addBitmapData("star1", "./resources/sprites/star1.png");
  resourceManager.addBitmapData(
      "spaceship1", "./resources/sprites/spaceship4.png");

  resourceManager.addBitmapData(
      "terrain1", "./resources/backgrounds/terrain1.jpg");
  resourceManager.addBitmapData("laser1", "./resources/sprites/laser2.png");
  resourceManager.addBitmapData("box", "./resources/sprites/box.png");

  resourceManager.addBitmapData("person", "./resources/sprites/person.png");

  await resourceManager.load();
  return resourceManager;
}
