import 'dart:async';
import 'dart:html';
import 'game_loop.dart';

class PlayerData {
	String id;
	double x;
	double y;
	double rotation;
}

class GameSocket {
	WebSocket webSocket;
	String id;
	Map<String, PlayerData> players;
	GameLoop currentGameLoop;
	
	GameSocket(this.currentGameLoop) {
		players = new Map<String, PlayerData>();
		webSocket = new WebSocket('ws://192.168.20.10:1825/Laputa');
		webSocket.onOpen.listen(onOpen);
		webSocket.onMessage.listen(onMessage);
		webSocket.onClose.listen(onClose);
	}
	
	void updatePosition(double x, double y, double rotation) {
		webSocket.sendString("0|" + x.toString() + "|" + y.toString() + "|" + rotation.toString());
	}
	
	onOpen(open) {
		webSocket.send("Connected");
	}
	
	onMessage(MessageEvent message) {
		String data = message.data;
		List<String> list = data.split("|");
		
		if (list[0] == "0") {
			id = list[1];
			print("My id: " + id);
		} else if (list[0] == "1") {
			for (int i = 1;i<list.length;i++) {
				
				List<String> playerData = list[i].split("/");
				String playerId = playerData[0];
				double playerX = double.parse(playerData[1]);
				double playerY = double.parse(playerData[2]);
				double playerRotation = double.parse(playerData[3]);
				if (playerId != id) {
					//print("data received!");
					if (!players.containsKey(playerId)) {
						players[playerId] = new PlayerData();
						players[playerId].id = playerId;
					}
					players[playerId].x = playerX;
					players[playerId].y = playerY;
					players[playerId].rotation = playerRotation;
					
					//print(list[i]);
					//print(playerId +  " X:" + playerX.toInt().toString() + " Y:" + playerY.toInt().toString());
				}
			}
			
			if (currentGameLoop != null) {
				//print("update!");
				currentGameLoop.updateNetwork();
			}
		} else if (list[0] == "3") {
			String removeId = list[1];
			players[removeId] = null;
			currentGameLoop.updateRemoveNetwork(removeId);
		}
		
		//print("Data Received: " + message.data);
	}
	
	onClose(ev) {
		print("Connection closed");
	}
}