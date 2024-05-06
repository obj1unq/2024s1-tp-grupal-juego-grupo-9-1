import wollok.game.*

object randomizer {
	/*
	 * Aclaracion: Modificar los 
	 */
	method randomX(){
		return (2..(game.width() - 2)).anyOne()
	}
	method randomY(){
		return (1..(game.height() - 5)).anyOne()
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
