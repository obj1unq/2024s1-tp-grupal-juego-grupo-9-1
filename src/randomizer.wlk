import wollok.game.*
import nivel.*

object randomizer {
	/*
	 * Aclaracion: Modificar los 
	 */
	method randomX(){
		return (1..game.width() -1).anyOne()
	}
	method randomY(){
		return (0..game.height() -1).anyOne()
	}
	method randomPosition(){
		return game.at(self.randomX(),self.randomY())
	}
	method emptyPosition() {
		const pos = self.randomPosition()
		return if (escenario.estaDentro(pos) && game.getObjectsIn(pos).isEmpty()) {pos} 
		else {self.emptyPosition()}
	}
}
