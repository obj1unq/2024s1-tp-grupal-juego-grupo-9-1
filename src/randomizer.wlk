import wollok.game.*

object randomizer {
	
	method randomX(){
		return (1..(game.width() - 1)).anyOne()
	}
	method randomY(){
		return (1..(game.height() - 1)).anyOne()
	}
	method randomPosition(){
		return game.at(self.randomX(),self.randomY())
	}
	method emptyPosition() {
		const pos = self.randomPosition()
		return if (game.getObjectsIn(pos).isEmpty()) {pos} 
		else {self.emptyPosition()}
	}
}
