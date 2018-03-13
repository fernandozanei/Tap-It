import Foundation

class Scoreboard {
	
	var players = [Player]()
	
	func addPlayer(name:String) {
		if !self.players.contains(where: { (player) -> Bool in
			player.name == name
		}) {
			let player = Player(id: self.players.count, name: name)
			self.players.append(player)
		}
	}
	
	func deletePlayer(name:String) {
		if let position = self.players.index(where: { (player) -> Bool in
			player.name == name
		}) {
			self.players.remove(at: position)
		}
	}
	
	func hasEverybodyJoined() -> Bool {
		for player in self.players {
			if !player.hasJoined {
				return false
			}
		}
		return true
	}
	
	func playerIsJoining(playerName: String) {
		if let index = self.players.index(where: { (player) -> Bool in
			return player.name == playerName
		}) {
			self.players[index].hasJoined = true
		}
	}
}